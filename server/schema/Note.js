const mongoose = require('mongoose');

const noteSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true
    },
    body: String,
    created: {
        type: Date,
        default: Date.now
    }
})

module.exports = mongoose.model('Note', noteSchema);
