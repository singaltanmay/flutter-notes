const createError = require('http-errors');
const express = require('express');
const path = require('path');

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

app.use(express.json());
app.use(express.urlencoded({extended: false}));
app.use(express.static(path.join(__dirname, 'public')));

// HTTP method declarations
app.get('/', getAllNotes)
app.post('/', saveNote)
app.delete('/', deleteAllNotes)
app.delete('/:noteId', deleteNote)
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
    res.render('error');
});

const noteSchema = new mongoose.Schema({
    title: {type: String, required: true}, body: String, created: {type: Date, default: Date.now}
})

const Note = mongoose.model('Note', noteSchema);

function getAllNotes(req, res, next) {
    Note.find().then(notes => {
        res.send(notes)
    }).catch(err => {
        console.log(err)
        next(err)
    });
}

function saveNote(req, res, next) {
    const note = new Note({
        title: req.body.title, body: req.body.body
    });
    note.save()
        .then(note => {
            res.sendStatus(200);
        }).catch(err => {
        next(err)
    });
}

function deleteAllNotes(req, res, next) {
    Note.deleteMany().then(res.sendStatus(200)).catch(next)
}

function deleteNote(req, res, next) {
    Note.deleteOne({'_id': req.params.noteId}).then(res.sendStatus(200)).catch(next)
}

module.exports = app;
