export { }   // set fs module

import md5 from 'md5'
import { getstr_s_h, print_s_h } from './TsMyListenerImpl'

const ALL_CONFIG = "all config"
const ALL_ZONE = "all zone"
const ALL_ALIAS = "all alias"
type As = Array<string>
type MsAs = Map<string, As>
type AMsAs = Array<MsAs>
type MsMsAs = Map<string, MsAs>
type FMsMsAs = (zs: MsMsAs) => any
type FParser = (input: string, recvzsfn?: FMsMsAs) => void
type FPrintsh = (name: string, head: MsAs) => void

declare global {
    interface Window {
        md5: (s: string) => string
        zs?: MsMsAs
        zs_md5?: string[]
        zs_inkvs?: Map<string, string>
        zs_outkvs?: Map<string, MsMsAs>
        parser: FParser
        print_s_h: FPrintsh
    }

    function gendot(id: string, sss: string): void
}
window.md5 = md5;

function recvzsfn(zsmap: MsMsAs) {
    console.log(new Date(), typeof zsmap)
    window['zs'] = zsmap
}

function readAndParse(data: string | MouseEvent) {
    if (data instanceof MouseEvent) {
        const ta1 = document.getElementById('zrs') as HTMLTextAreaElement
        data = ta1.value
    }
    let bPos = 0
    const zs_md5: string[] = []
    const zs_inkvs: Map<string, string> = new Map()
    const zs_outkvs: Map<string, MsMsAs> = new Map()
    window.zs_md5 = zs_md5
    window.zs_inkvs = zs_inkvs
    window.zs_outkvs = zs_outkvs
    while (bPos != -1) {
        const iB = data.indexOf('Defined configuration:', bPos);
        if (iB == -1) {
            console.warn('not found cfg');
            break
        };
        let d1 = data.substring(iB);
        let iE = /\s*^.+\>|\s*^\s*\{/m.exec(d1);
        if (iE) {
            d1 = d1.substring(0, iE.index)
            bPos += iE.index
        } else {
            bPos = -1
            iE = /\s+$/.exec(d1)
            if (iE)
                d1 = d1.substring(0, iE.index)
        }

        const md5s = md5(d1) as string
        zs_md5.push(md5s)
        zs_inkvs.set(md5s, d1)
        console.warn(`all input ${data.length} bytes, found ${iB}..${iB + (iE ? iE.index : d1.length)} of ${d1.length} bytes, ${md5s}`);
    }

    const zouts = document.getElementById('zouts') as HTMLDivElement
    zouts.innerHTML = ''
    for (let i = 0; i < zs_md5.length; i++) {
        const md5s = zs_md5[i]
        const t0 = new Date()
        if (zs_outkvs.has(md5s)) {
            console.warn(`parse no.${i} ${md5s} same as other, skip`)
            continue
        }
        let res: MsMsAs
        console.warn(`parse no.${i} ${md5s} begin at ${t0.valueOf()}`);
        window.parser(zs_inkvs.get(md5s)!, e => res = e)
        console.warn(`parse no.${i} ${md5s} use ${new Date().valueOf() - t0.valueOf()} milliseconds`);
        zs_outkvs.set(md5s, res!)
        output(i, res!)
    }
    console.warn(`Parse all ${zs_md5.length} DONE.`)
}

function output(i: number, res: MsMsAs) {
    const divout = document.createElement('div') as HTMLDivElement
    const zouts = document.getElementById('zouts') as HTMLDivElement
    zouts.appendChild(divout)
    const outas: HTMLTextAreaElement[] = []
    for (let j = 1; j <= 8; j++) {
        const zout = document.createElement('textarea') as HTMLTextAreaElement
        zout.setAttribute('id', `zout${i}${j}`)
        zout.setAttribute('rows', "15")
        zout.setAttribute('cols', "40")
        zout.setAttribute('wrap', 'off')
        zout.style.backgroundColor = '#dddddd'
        divout.appendChild(zout)
        outas[j] = zout
    }

    const cfgs = res.get(ALL_CONFIG)!
    const zones = res.get(ALL_ZONE)!
    const aliass = res.get(ALL_ALIAS)!
    const effz = [...res.keys()][3]
    const effzs = res.get(effz)!

    let ll;
    ll = (x: string) => outas[1].value += x + "\n"
    {
        ll(`==== 1-defined_config_summary.log`)
        ll(`\n#### Defined config summary: \ncfgs: ${cfgs.size}  zones: ${zones.size}  aliass: ${aliass.size}`)
        ll(getstr_s_h(ALL_CONFIG, cfgs))
        ll(getstr_s_h(ALL_ZONE, zones))
        ll(getstr_s_h(ALL_ALIAS, aliass))
    }
    ll = (x: string) => outas[2].value += x + "\n"
    {
        ll(`==== 2-effective_config.log`)
        ll('\n#### Effective config:')
        ll(getstr_s_h(`'${effz}'`, effzs))
    }
    ll = (x: string) => outas[3].value += x + "\n"
    {
        ll(`==== 3-defined_config_split_expand_ports.log`)
        ll('\n#### Show defined config split and expand ports:')
        ll('{')
        cfgs.forEach((zns, cfgname) => {
            ll(`"${cfgname}"=>{`)
            zns.forEach(zn => {
                const pts = zones.get(zn)!
                const pts2 = pts.map(v => { const v2 = (v.indexOf(',') != -1 || v.indexOf(':') != -1) ? v : aliass.get(v)!; return `"${v2}"`; })
                ll(` "${zn}"=>[ ${pts2.join(', ')} ], `)
            })
            ll(' }')
        })
        ll('}')
    }
    ll = (x: string) => outas[4].value += x + "\n"
    {
        ll(`==== 4-diff_effective_defined_confg.log`)
        const [res, msg] = rbcomp(effzs, cfgs.get(effz)!, aliass, zones)
        ll(`\n### Same Result Effective config and Defined config ? \n [${res}] \n ${msg}`)

    }
    ll = (x: string) => outas[5].value += x + "\n"
    {
        const generate_effictive_create_script_from_effx = (effzs: MsAs): string[] => {
            const str_s: string[] = []
            effzs.forEach((v, k) => {
                const vs = v.join(';')
                if (vs.indexOf('"') != -1) str_s.push(`Error: zone join have " `)
                str_s.push(` zonecreate "${k}","${vs}" ;`)
            })
            str_s.push('')
            const vs = [...effzs.keys()].join(';')
            if (vs.indexOf(':') != -1) str_s.push(`Error: cfg join have " `)
            str_s.push(`cfgcreate "${effz}","xxx" ;`);
            [...effzs.keys()].forEach(zn => {
                str_s.push(` cfgadd "${effz}","${zn}" ;`)
            })
            str_s.push(`cfgremove "${effz}","xxx" ;`)
            str_s.push(` # cfgsave`)
            str_s.push('')

            return str_s
        }
        ll(`==== 5-create_script_from_effective.log`)
        ll(`\n\n#### from Effective config generated Create Script:`)

        const res = generate_effictive_create_script_from_effx(effzs)
        ll(res.join("\n"))
    }
    ll = (x: string) => outas[6].value += x + "\n"
    {
        const generate_all_create_script_from_defx = (cfgs: MsAs, zones: MsAs, aliass: MsAs): string[] => {
            let str_s: string[] = []
            aliass.forEach((v, k) => {
                let vs = v.join(';')
                if (vs.indexOf('"') != -1) str_s.push(`Error: alias join have " `)
                str_s.push(` alicreate "${k}","${vs}" ;`)
            })
            str_s.push('')
            zones.forEach((v, k) => {
                let vs = v.join(';')
                if (vs.indexOf('"') != -1) str_s.push(`Error: zone join have " `)
                str_s.push(` zonecreate "${k}","${vs}" ;`)
            })
            str_s.push('')
            cfgs.forEach((v, k) => {
                let vs = v.join(';')
                if (vs.indexOf('"') != -1) str_s.push(`Error: cfg join have " `)
                str_s.push(`cfgcreate "${k}","xxx" ;`)
                v.forEach(zn => {
                    str_s.push(` cfgadd "${k}","${zn}" ;`)
                })
                str_s.push(`cfgremove "${k}","xxx" ;`)
            })
            str_s.push('')
            str_s.push(' # cfgsave')
            return str_s
        }
        ll(`==== 6-create_script_all_from_defined_config.log`)
        ll(`\n\n#### from Defined config generated Create Script:`)
        const res = generate_all_create_script_from_defx(cfgs, zones, aliass)
        ll(res.join("\n"))

    }
    ll = (x: string) => outas[7].value += x + "\n"
    {
        const generate_split_cfg_create_script_from_defx = (cfgs: MsAs, zones: MsAs, aliass: MsAs): Map<string, string[]> => {
            let rvs = new Map<string, string[]>()
            cfgs.forEach((zns, cfgname) => {
                let str_s: string[] = []
                rvs.set(cfgname, str_s)
                let usedalias: As = zns.map(zn => {
                    return zones.get(zn)!
                }).flat()
                str_s.push(`-- ${cfgname}`);
                [...new Set(usedalias)].sort().forEach(ali => {
                    let v = aliass.get(ali)
                    if (v) str_s.push(` alicreate "${ali}","${v.join(';')}" ;`)
                    else if (ali.indexOf(',') == -1 && ali.indexOf(':') == -1) str_s.push('??')
                })
                str_s.push('')
                zns.forEach(zn => {
                    let v = zones.get(zn)!
                    str_s.push(` zonecreate "${zn}","${v.join(';')}" ;`)
                })
                str_s.push('')
                str_s.push(`cfgcreate "${cfgname}","xxx" ;`)
                zns.forEach(zn => {
                    let v = zones.get(zn)!
                    str_s.push(` cfgadd "${cfgname}","${zn}" ;`)
                })
                str_s.push(`cfgremove "${cfgname}","xxx" ;`)

                str_s.push(' # cfgsave')
                str_s.push('')
            })

            return rvs
        }
        let rvs = generate_split_cfg_create_script_from_defx(cfgs, zones, aliass)
        rvs.forEach((v, k) => {

            ll(`==== 7-create_script_${k}_from_defined_config.log`)
            ll(`\n\n#### from Defined config ${k} generated Create Splited Script:`)
            ll(v.join("\n"))
            ll('')
        })

    }
    ll = (x: string) => outas[8].value += x + "\n"
    {
        const remove_not_effactive_cfg = (cfgs: MsAs, zones: MsAs, aliass: MsAs, effz: string): string[] => {
            let str_s: string[] = []
            let usedzns: As, usedalias: As;

            cfgs.forEach((zns, cfgname) => {
                if (effz === cfgname) {
                    usedzns = zns
                    usedalias = usedzns.map(zn => {
                        return zones.get(zn)!
                    }).flat()
                } else {
                    str_s.push(`cfgdelete "${cfgname}" ;`)
                }
            });
            str_s.push('');
            [...zones.keys()].forEach(zn => {
                if (!usedzns.includes(zn)) {
                    str_s.push(`zonedelete "${zn}" ;`)
                }
            })
            str_s.push('');
            [...aliass.keys()].forEach(alin => {
                if (!usedalias.includes(alin)) {
                    str_s.push(`alidelete "${alin}" ;`)
                }
            })
            str_s.push('')
            return str_s
        }
        ll(`==== 8-remove_not_effactive_cfg.log`)
        ll(`\n\n#### delete not Effectived config, Keeped {${effz}} :`)
        let res = remove_not_effactive_cfg(cfgs, zones, aliass, effz)
        ll(res.join("\n"))

    }
}

function difference(setA: As | Set<string>, setB: As | Set<string>) {
    const diff = new Set(setA);
    for (const elem of setB) {
        diff.delete(elem);
    }
    return diff;
}

function rbcomp(effzs: MsAs, cfgzns: As, aliass: MsAs, zones: MsAs): [boolean, string] {
    const ezsks = [...effzs.keys()]
    if (ezsks.length != cfgzns.length) {
        return [false, `zones number diff`];
    }
    const s1 = difference(ezsks, cfgzns)
    const s2 = difference(cfgzns, ezsks)
    if (s1.size > 0 || s2.size > 0) {
        return [false, `zone names diff (${[...s1]}), (${[...s2]})`];
    }

    ezsks.sort()
    cfgzns.sort()
    for (let i = 0; i < ezsks.length; i++) {
        const xpts = effzs.get(ezsks[i])!
        const ypts = zones.get(cfgzns[i])!.map(e => { return (e.indexOf(',') != -1 || e.indexOf(':') != -1) ? [e] : aliass.get(e)! }).flat()
        if (xpts.length != ypts.length) {
            return [false, `zone ${ezsks[i]} pts number diff`];
        }
        const s1 = difference(xpts, ypts)
        const s2 = difference(ypts, xpts)
        if (s1.size > 0 || s2.size > 0) {
            return [false, `pt name diff (${[...s1]}), (${[...s2]})`];
        }
    }

    return [true, ''];
}


function readFile(filename: File, encoding: string = '') {
    const f = new FileReader()
    f.onload = function (e) {
        const str = new TextDecoder(encoding === '' ? undefined : encoding).decode(f.result as ArrayBuffer)
        readAndParse(str)
        const ta1 = document.getElementById('zrs') as HTMLTextAreaElement
        ta1.value = str
    }
    f.readAsArrayBuffer(filename);
}

window.addEventListener('load', () => {
    const s1 = document.getElementById('encode_sel') as HTMLSelectElement
    const e1 = document.getElementById('encode_name') as HTMLInputElement
    const f1 = document.getElementById('f1') as HTMLInputElement
    const rr = function () {
        if (f1.files && f1.files.length > 0) {
            readFile(f1.files[0], e1.value.trim())
        }
    }
    s1.addEventListener('change', () => {
        e1.value = s1.options[s1.selectedIndex].value;
        rr()
    })
    e1.value = s1.options[s1.selectedIndex].value;
    f1.addEventListener('change', rr)

    const linewrap = document.getElementById('wrap') as HTMLInputElement
    const ta1 = document.getElementById('zrs') as HTMLTextAreaElement
    linewrap.addEventListener('change', () => {
        ta1.setAttribute('wrap', linewrap.checked ? 'on' : 'off')
    })
    ta1.setAttribute('wrap', linewrap.checked ? 'on' : 'off')

    let btn = document.getElementById('btnparse') as HTMLButtonElement
    btn.addEventListener('click', readAndParse)
    btn = document.getElementById('resetfile') as HTMLButtonElement
    btn?.addEventListener('click', () => {
        f1.value = ''
        ta1.value = ''
        window.zs_md5 = undefined
        window.zs_inkvs = undefined
        window.zs_outkvs = undefined
    })


    ;{
        const in_svrs = document.getElementById('in_svrs') as HTMLTextAreaElement
        const in_stors = document.getElementById('in_stors') as HTMLTextAreaElement
        const to_cfgname = document.getElementById('to_cfgname') as HTMLTextAreaElement
        const out_scr = document.getElementById('out_scr') as HTMLTextAreaElement
        const generate_create_zone = document.getElementById('generate_create_zone')

        const ll = msg => out_scr.value += msg + "\n"

        generate_create_zone?.addEventListener('click', () => {
            const srvs = in_svrs.value.trim().split(/\r|\n|\r\n/)
            const stors = in_stors.value.trim().split(/\r|\n|\r\n/)
            let cfgname = to_cfgname.value.trim()
            cfgname === '' ? cfgname = 'XXX' : cfgname
            const zs: string[] = []
            if (srvs.length <= 0 || stors.length <= 0) return

            srvs.forEach(v => {
                stors.forEach(d => {
                    ll(` zonecreate "${v}_${d}","${v};${d}" ;`)
                    zs.push(`${v}_${d}`)
                })
            })
            ll(`cfgadd "${cfgname}","${zs.join(';')}" ;`)
            ll(`# cfgsave`)
            ll(`# cfgenable ${cfgname}\n\n`)
        })

        const in_dev = document.getElementById('in_dev') as HTMLTextAreaElement
        const generate_remove_zone = document.getElementById('generate_remove_zone')
        generate_remove_zone?.addEventListener('click', () => {
            const remove_pts = in_dev.value.trim().split(/\r|\n|\r\n/)
            if (remove_pts.length <= 0) return

            const md = window.zs_md5?.[window.zs_md5.length - 1]
            if (!md) return
            const kvs = window.zs_outkvs?.get(md)!
            if (!kvs) return
            const actzn = [...kvs.keys()].filter(v => !([ALL_CONFIG, ALL_ZONE, ALL_ALIAS].includes(v)))
            if (actzn.length != 1) return
            const zsns = kvs.get(ALL_CONFIG)!.get(actzn[0])!
            const zes = kvs.get(ALL_ZONE)!

            const del_zones: string[] = []
            zsns.forEach(zn1 => {
                const pts = new Set(zes.get(zn1)!)
                remove_pts.forEach(pt => {
                    if (pts.has(pt)) {
                        if (pts.size <= 2) {
                            ll(` zonedelete "${zn1}" ;`)
                            del_zones.push(zn1)
                        } else if (pts.size > 2) {
                            ll(` zoneremove "${zn1}","${pt}" ;`)
                        }
                    }
                })
            })

            del_zones.forEach(del_zn => {
                const zones = kvs.get(ALL_CONFIG)!
                zones.forEach((zns, cfg) => {
                    if (zns.includes(del_zn))
                        ll(` cfgremove "${cfg}","${del_zn}" ;`)
                })
            })
            ll(`# cfgsave`)
            ll(`# cfgenable ${actzn}\n\n`)
        })
    }

    ;{
        const in_dot = document.getElementById('in_dot') as HTMLTextAreaElement
        const btn_gendot = document.getElementById('btn_gendot') as HTMLButtonElement
        const btn_dot2svg = document.getElementById('btn_dot2svg') as HTMLButtonElement
        btn_gendot.addEventListener('click', () => {

            const md = window.zs_md5?.[window.zs_md5.length - 1]
            if (!md) return
            const kvs = window.zs_outkvs?.get(md)!
            if (!kvs) return
            const actzn = [...kvs.keys()].filter(v => !([ALL_CONFIG, ALL_ZONE, ALL_ALIAS].includes(v)))
            if (actzn.length != 1) return
            const zsns = kvs.get(ALL_CONFIG)!.get(actzn[0])!
            const zes = kvs.get(ALL_ZONE)!

            const lks = zsns.map(zn=>{
                const pts = zes.get(zn)!
                return pts.map(pt=>`${zn} -- "${pt}" ;`).join("\n")
            })
            let s2 = `graph {
${zsns.map(zn=>`${zn}[shape=box];`).join("\n")}

${lks.join("\n")}
            }
            `
            in_dot.value = s2
            console.log(`gen dot script done.`)
        })
        btn_dot2svg.addEventListener('click', () => {
            const sss = in_dot.value
            gendot('#graph', sss)
            console.log(`dot gen svg done.`)
        })
    }
})
