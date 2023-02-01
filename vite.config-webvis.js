export default {
    build: {
        rollupOptions: {
            input: {
                main: 'index-vis.html'
            },
        },
        target: 'chrome58',
        outDir: 'webgui-vis-release',

    }
}