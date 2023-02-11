export default {
    build: {
        rollupOptions: {
            input: {
                main: 'index-vis.html'
            },
        },
        target: 'chrome58',
        minify: false,
        outDir: 'webgui-vis-release',

    }
}

