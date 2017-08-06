exports.handler = (event, context, callback) => {
    const host = (event && event.host) || 'www.markistaylor.com';
    const path = (event && event.path) || '';
    const wwwhost = host.startsWith('www.') ? host : 'www.' + host;
    const location = 'https://' + wwwhost + '/' + path;
    
    callback(null, {
        'location': location,
        'cache': 'public, max-age=86400'
    });
};