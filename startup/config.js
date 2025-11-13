require('dotenv').config();

module.exports = function() {
  if (!process.env.JWT_PRIVATE_KEY) {
    throw new Error('FATAL Error: JWT_PRIVATE_KEY not defined!');
  }

};
