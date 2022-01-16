var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

const mongoose = require('mongoose');

const server = '127.0.0.1:27017';
const database = 'flutter-notes-db';

mongoose.connect(`mongodb://${server}/${database}`, {
    useNewUrlParser: true, useUnifiedTopology: true
}).then(() => {
    console.log('Flutter Notes database connected!!');
}).catch(err => {
    console.log('Failed to connect to Flutter Notes database', err);
});

var usersRouter = require('./routes/users');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({extended: false}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// HTTP method declarations
app.get('/', getAllNotes)
app.post('/', saveNote)
app.delete('/', deleteAllNotes)
app.delete('/:noteId', deleteNote)

app.use('/users', usersRouter);

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

function deleteNote(req, res, next){
    Note.deleteOne({'_id': req.params.noteId}).then(res.sendStatus(200)).catch(next)
}

module.exports = app;
