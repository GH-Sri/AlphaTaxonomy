const webpack = require('webpack')

module.exports = {
    plugins: [
        new webpack.DefinePlugin({
            'process.env': {
                ENDPOINT_HOST: JSON.stringify(process.env.ENDPOINT_HOST)
            }
        })
    ]
}