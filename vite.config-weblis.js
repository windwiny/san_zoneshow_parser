export default {
    build: {
        rollupOptions: {
            input: {
                main: 'index-lis.html'
            },
        },
        target: 'chrome58',
        minify: false,
        outDir: 'webgui-lis-release',

    }
}

