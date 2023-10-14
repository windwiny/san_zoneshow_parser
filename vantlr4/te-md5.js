window.p2 = new Date()
import * as an from 'antlr4'

import { CharStream, CommonTokenStream, ParseTreeWalker } from "antlr4";

import md5 from 'md5' // vite >= v4.4.11 ok

// import {md5} from './md5esm.js'


window.addEventListener('load', () => {
    let f1 = document.getElementById('f1')
    f1.addEventListener('change', (e) => {
        console.log(an.InputStream, an.FileStream)
        console.log(CharStream, CommonTokenStream, ParseTreeWalker)
        console.log('on change ', e, md5('abcdefg'))
    })
})
