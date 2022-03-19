const createError = require('http-errors');
const express = require('express');
const path = require('path');
const cors = require('cors');
const jwt = require('jsonwebtoken')

const mongoose = require('mongoose');

const server = '127.0.0.1:27017';
const database = 'flutter-notes-db';
const TOKEN_SECRET = 'QKKawsbKW1OgC5FIvcEtjjsnLTkVbFRi7ITxnjId'

let mongooseConnected = false;
let mongoUrl = `mongodb://${server}/${database}`;

const connectWithRetry = function () {
    return mongoose.connect(mongoUrl, {
        useNewUrlParser: true, useUnifiedTopology: true
    }, function (err) {
        if (err) {
            console.log('Failed to connect to Flutter Notes database on startup. Retrying in 5 sec', err);
            setTimeout(connectWithRetry, 5000);
        } else {
            mongooseConnected = true;
            console.log('Flutter Notes database connected!\n');
        }
    })
};
connectWithRetry();

const app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(cors())
app.use(express.json());
app.use(express.urlencoded({extended: false}));
app.use(express.static(path.join(__dirname, 'public')));

// HTTP method declarations
app.get('/', getAllNotes)
app.post('/', saveNote)
app.delete('/', deleteAllNotes)
app.delete('/:noteId', deleteNote)
app.put('/', updateNote)
app.get('/user', getUserByToken)
app.post('/user', signUpUser)
app.post('/signin', signInUser)
app.get('/health', (_, res) => res.send(mongooseConnected))

// catch 404 and forward to error handler
app.use(function (req, res, next) {
    next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
    // set locals, only providing error in development
    res.locals.message = err.message;
    res.locals.error = req.app.get('env') === 'development' ? err : {};

    // render the error page
    res.status(err.status || 500);
    res.send(JSON.stringify(err));
});

// Schema imports
const Note = require('./schema/Note')
const User = require('./schema/User')
const Token = require('./schema/Token')

function getAllNotes(req, res, next) {
    Note.find().then(notes => {
        res.send(notes)
    }).catch(err => {
        console.log(err)
        next(err)
    });
}

async function saveNote({query, body}, res, next) {
    let userId = await getUserIdByToken(query.token);
    const note = new Note({
        title: body.title, body: body.body, created: body.created, starred: body.starred
    })
    const creator = await User.findById(userId)
    if (creator == null) {
        let errorMsg = "Cannot save note without a valid creator";
        console.log(errorMsg + "\n" + note)
        res.status(400).send(errorMsg);
        next()
    } else {
        note.creator = creator
    }
    note.save()
        .then(_ => {
            res.sendStatus(200);
        }).catch(err => {
        next(err)
    });
}

async function updateNote({body}, res, next) {
    const oldNote = await Note.findById(body._id);
    if (oldNote == null) {
        res.sendStatus(404)
        return;
    }
    Note.updateOne({'_id': body._id}, {
        'title': body.title || oldNote['title'],
        'body': body.body || oldNote['body'],
        'created': body.created || oldNote['created'],
        'creator': body.creator || oldNote['creator'],
        'starred': body.starred || oldNote['starred']
    }).then(_ => {
        res.sendStatus(200);
    }).catch(err => {
        console.log(err)
        next(err)
    })
}

function deleteAllNotes(req, res, next) {
    Note.deleteMany().then(res.sendStatus(200)).catch(next)
}

function deleteNote(req, res, next) {
    Note.deleteOne({'_id': req.params.noteId}).then(res.sendStatus(200)).catch(next)
}

async function getUserByToken(req, res, next) {
    const token = req.query.token
    let userId = await getUserIdByToken(token);
    User.findById(userId).then(user => {
        res.status(200).send(user.redactedJson());
    }).catch(err => {
        console.log(err)
        res.status(404).send()
        next(err)
    })
}

async function signInUser(req, res, next) {
    await User.findOne({
        'username': req.body.username, 'password': req.body.password
    }).then(user => {
        // Create JWT
        let userId = user._id.toString();
        const jwToken = jwt.sign({"username": userId}, TOKEN_SECRET, {expiresIn: '1800s'})
        const token = new Token({
            user: userId, token: jwToken
        });
        token.save().then(_ => {
            res.status(200).send(jwToken);
        }).catch(err => {
            console.log(err)
            next(err)
        });
    }).catch(err => {
        console.log(err)
        next(err)
    });
}

function signUpUser(req, res, next) {
    const user = new User({
        username: req.body.username,
        password: req.body.password,
        securityQuestion: req.body.securityQuestion,
        securityQuestionAnswer: req.body.securityQuestionAnswer
    });
    user.save()
        .then(_ => {
            return (signInUser(req, res, next))
        }).catch(err => {
        console.log(err)
        next(err)
    });
}

async function getUserIdByToken(token) {
    if (!token) return null;
    const tokenObj = await Token.findOne({token: token});
    if (tokenObj && tokenObj.user) {
        return tokenObj.user.toString()
    } else return null;
}

module.exports = app;
