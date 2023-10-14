window.addEventListener('load', ()=>{
    const v1 = document.getElementById('v1') as HTMLTextAreaElement
    const v2 = document.getElementById('v2') as HTMLTextAreaElement
    const d11 = document.getElementById('d11') as HTMLTextAreaElement
    const d12 = document.getElementById('d12') as HTMLTextAreaElement
    const d13 = document.getElementById('d13') as HTMLTextAreaElement
    const d14 = document.getElementById('d14') as HTMLTextAreaElement
    const info1 = document.getElementById('info1') as HTMLPreElement
    v1.addEventListener('change',()=>{

        const t1 = v1.value.trim()
        const ls1 = t1.split(/\r|\n|\r\n/)
        const ls11 = [...new Set(ls1)]
        const t2 = v2.value.trim()
        const ls2 = t2.split(/\r|\n|\r\n/)
        const ls22 = [...new Set(ls2)]

        info1.textContent = `
lines ${ls1.length}  uniq ${ls11.length}
lines ${ls2.length}  uniq ${ls22.length}
        `

        const comm =  ls11.filter(v=>ls22.includes(v))


        ;const all = [...new Set(ls1.concat(ls2))]
        d11.value = all.join("\n")

        d12.value = comm.join("\n")

        d13.value = ls11.filter(v=> !ls22.includes(v) ).join("\n")

        d14.value = ls22.filter(v=> !ls11.includes(v) ).join("\n")



    })
})
