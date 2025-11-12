const webpack = require('webpack')

module.exports = {
    publicPath: './',
    assetsDir: 'static',
    productionSourceMap: false,
    configureWebpack: {
        plugins: [
            new webpack.ProvidePlugin({
                $: "jquery",
                jQuery: "jquery",
                "windows.jQuery": "jquery"
            })
        ]
    },
    devServer: {
        port: 8080, // 本地开发端口
        proxy: {
            '/api': {
                target: 'http://localhost:8080', // 本地后端地址
                changeOrigin: true,
                pathRewrite: {
                    '^/api': '' // 关键：删除 URL 中的 /api 前缀
                }
            }
        }
    }
};