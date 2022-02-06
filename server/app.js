const createError = require('http-errors');
const express = require('express');
const path = require('path');
const cors = require('cors');

const mongoose = require('mongoose');

const server = '127.0.0.1:27017';
const database = 'flutter-notes-db';

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
app.get('/user', getAllUsers)
app.post('/user', signUpUser)
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

const Note = require('./schema/Note')
const User = require('./schema/User')

function getAllNotes(req, res, next) {
    Note.find().then(notes => {
        res.send(notes)
    }).catch(err => {
        console.log(err)
        next(err)
    });
}

function saveNote({body}, res, next) {
    const note = new Note({
        title: body.title,
        body: body.body,
        created: body.created
    })
    note.save()
        .then(_ => {
            res.sendStatus(200);
        }).catch(err => {
        next(err)
    });
}

async function updateNote({body}, res, next) {
    const oldNote = await Note.findById(body._id);
    if(oldNote == null){
        res.sendStatus(404)
        return;
    }
    Note.updateOne({'_id': body._id}, {
        'title': body.title || oldNote['title'],
        'body': body.body || oldNote['body'],
        'created': body.created || oldNote['created'],
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

function getAllUsers(req, res, next) {
    User.find().then(users => {
        res.send(users)
    }).catch(err => {
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
            res.sendStatus(200);
        }).catch(err => {
        console.log(err)
        next(err)
    });
}

module.exports = app;
