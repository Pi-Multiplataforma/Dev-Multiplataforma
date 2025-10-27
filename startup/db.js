const mongoose = require('mongoose');
require('dotenv').config();

module.exports = async function connectToDB() {
    try{
        await mongoose.connect(
            process.env.MONGO_URI
        );
        console.log('connected to db');
    } catch(error){
        console.log(error);
        throw error;
    }
}