export default {
    build: {
        rollupOptions: {
            input: {
                main: 'index-lis.html'
            },
        },
        target: 'chrome58',
        outDir: 'webgui-lis-release',

    }
}
