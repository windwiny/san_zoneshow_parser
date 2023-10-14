
export default {
    build: {
        rollupOptions: {
            input: {
                main: 'index-test.html'
            },
        },
        target: 'chrome58',
        minify: false,
        outDir: 'webgui-test',

    }
}

