exports.handler = (event, context, callback) => {
  const name = event.name || 'Lambda';
  callback(null, `Hello ${name}!`);
};