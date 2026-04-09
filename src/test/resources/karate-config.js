function fn() {
    var env = karate.env || 'qa';
    karate.log('ENV:', env);
    karate.configure('ssl',true)
    karate.configure('logPrettyRequest',true)
    karate.configure('logPrettyResponse',true)
    karate.configure('afterScenario', function() {
        try {
            if (karate.get('request')) {
                karate.embed(karate.get('request'), 'application/json');
            }
        } catch(e) {}
        try {
            if (karate.get('response')) {
                karate.embed(karate.get('response'), 'application/json');
            }
        } catch(e) {}
    });
    var envConfig = read('classpath:config/env/' + env + '.js')();
    var config = {
        env: env,
        urls: envConfig.urls
    };
    karate.log('Se amable, es mi primera vez')
    karate.log('URLS:', config.urls);
    return config;
}