module.exports = {
    uiPort: process.env.PORT || 1880,

    // Enable login authentication
    adminAuth: {
        type: "credentials",
        users: [
            {
                username: process.env.NODE_RED_USERNAME || "admin",
                password: process.env.NODE_RED_PASSWORD_HASH,
                permissions: "*"
            }
        ]
    },

    // Secure HTTP In endpoints (optional)
    // httpNodeAuth: {
    //     user: "apiuser",
    //     pass: process.env.NODE_RED_API_PASSWORD_HASH
    // },

    // Secret for encrypting credentials stored in flows
    credentialSecret: process.env.NODE_RED_CREDENTIAL_SECRET,

    // Allow Node-RED Projects
    editorTheme: {
        projects: {
            enabled: true
        }
    },

    // Logging
    logging: {
        console: {
            level: "info",
            metrics: false,
            audit: false
        }
    },

    // Disable external editor access if required through network controls
    functionExternalModules: true
};