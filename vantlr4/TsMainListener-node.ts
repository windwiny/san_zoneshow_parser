import process from 'process';

import { lis_parser, MsAs, MsMsAs } from './TsMyListenerImpl';

function afterfn(zs: MsMsAs) {
    let ass: Array<string> = []
    zs.forEach((value: MsAs, key: string) => {
        ass.push(`<${key}>: ${value.size}`)
    })
    console.error("SUMMARY: ", ass.join(", "))
}

function main() {
    process.stdin.setEncoding('utf8');
    let sss = '';
    let i = 0
    process.stdin.on('data', function (data: string) {
        i++
        sss += data
    })
    process.stdin.on('end', function () {
        lis_parser(sss, afterfn)
    })
}

main()
