export { }   // set fs module
type As = Array<string>
type MsAs = Map<string, As>
type AMsAs = Array<MsAs>
type MsMsAs = Map<string, MsAs>
type FMsMsAs = (zs: MsMsAs) => any
type FParser = (input: string, recvzsfn?: FMsMsAs) => void
type FPrintsh = (name: string, head: MsAs) => void

declare global {
    interface Window {
        zs?: MsMsAs
        parser: FParser
        print_s_h: FPrintsh
    }
}

function recvzsfn(zsmap: MsMsAs) {
    console.log(new Date(), typeof zsmap)
    window['zs'] = zsmap
}

function readAndParse(data: string | MouseEvent) {
    if (data instanceof MouseEvent) {
        let ta1 = document.getElementById('zrs') as HTMLTextAreaElement
        data = ta1.value
    }
    let t0 = new Date()
    console.log(`parse input ${data.length} bytes, at ${t0.valueOf()}`);
    window.parser(data, recvzsfn)
    console.log(`parser use ${new Date().valueOf() - t0.valueOf()} milliseconds`);
}

function readFile(filename: File) {
    let f = new FileReader()
    f.onload = function (e) {
        readAndParse(f.result as string)
        let ta1 = document.getElementById('zrs') as HTMLTextAreaElement
        ta1.value = f.result as string
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
