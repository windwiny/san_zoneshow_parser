import { vis_parser, print_s_h, MsMsAs } from './TsMyVisitorImpl';

declare global {
    interface Window {
        zs?: MsMsAs
    }
}

window['vis_parser'] = vis_parser
window['print_s_h'] = print_s_h


function recvzsfn(zsmap: MsMsAs) {
    console.log(new Date(), typeof zsmap)
    window['zs'] = zsmap
}

function readAndParse() {
    let ta1 = document.getElementById('zrs') as HTMLTextAreaElement
    let t0 = new Date()
    console.log(`parse input ${ta1.value.length} bytes, at ${t0.valueOf()}`);
    vis_parser(ta1.value, recvzsfn)
    console.log(`parser use ${new Date().valueOf() - t0.valueOf()} milliseconds`);
}

function readFile(filename: File) {
    let ta1 = document.getElementById('zrs') as HTMLTextAreaElement
    let f = new FileReader()
    f.onload = function (e) {
        ta1.value = f.result as string
        readAndParse()
    }
    f.readAsText(filename);
}

window.addEventListener('load', () => {
    let f1 = document.getElementById('f1') as HTMLInputElement
    f1.addEventListener('change', () => {
        if (f1.files && f1.files.length > 0) {
            readFile(f1.files[0])
        }
    })

    let btn = document.getElementById('btnparse') as HTMLButtonElement
    btn.addEventListener('click', readAndParse)
})
