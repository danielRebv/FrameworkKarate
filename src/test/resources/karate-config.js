function fn() {

    //  ENV
    var env = karate.env || 'dev';

    //  SERVICES
    var config = {
        env: env,
        services: {
            cuentas: 'https://dev.api.cuentas.com',
            pagos: 'https://dev.api.pagos.com',
            auth: 'https://dev.api.auth.com',
            demo: 'https://jsonplaceholder.typicode.com'
        }
    };

    //  CAMBIO POR AMBIENTE
    if (env == 'qa') {
        config.services = {
            cuentas: 'https://qa.api.cuentas.com',
            pagos: 'https://qa.api.pagos.com',
            auth: 'https://qa.api.auth.com',
            demo: 'https://jsonplaceholder.typicode.com'
        };
    }

    // 🔐 AUTH (feature desacoplado)
    var auth = karate.call('classpath:features/common/auth.feature');

    //  FUNCTION: headers dinámicos por servicio
    function buildHeaders(service) {

        var base = {
            'Content-Type': 'application/json'
        };

        if (service == 'cuentas') {
            base.canal = 'web';
        }

        if (service == 'pagos') {
            base.canal = 'mobile';
        }

        if (service == 'auth') {
            base.canal = 'internal';
        }

        // 🔐 token dinámico
        base.Authorization = 'Bearer ' + auth.token;

        return base;
    }

    // 📦 Exponer función a Karate
    config.buildHeaders = buildHeaders;

    return config;
}