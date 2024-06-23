{
    class Cst {
    constructor() {
        this.Nodes = [];
        this.Edges = [];
        this.idCount = 0;
    }

    newNode(){
        let count = this.idCount; 
        this.idCount++;
        return `${count}`
    }

    addNode(id, label){
        this.Nodes.push({
            id: id, 
            label: label,
        });
    }

    addEdge(from, to){
        this.Edges.push({
            from: from, 
            to: to,
        });
    }
}
  // Creando cst 
  let cst = new Cst();
  // Agregar nodos
  function newPath(idRoot, nameRoot, nodes) {
    cst.addNode(idRoot, nameRoot);
    for (let node of nodes) {
      if (typeof node !== "string"){
        cst.addEdge(idRoot, node?.id);
        continue;
      }
      let newNode = cst.newNode();
      cst.addNode(newNode, node);
      cst.addEdge(idRoot, newNode);
    }
  }
}
// Iniciamos el análisis sintáctico con la regla inicial "start"
/*
Start
  = gs:GlobalSection _? ds1:DataSection? _? ts:TextSection _? ds2:DataSection? {
    let dataSectionConcat = []
    if (ds1 != null) dataSectionConcat = dataSectionConcat.concat(ds1);
    if (ds2 != null) dataSectionConcat = dataSectionConcat.concat(ds2);
    // Agregando raiz cst
    let idRoot = cst.newNode();
    newPath(idRoot, 'Start', [gs, ds1, ts, ds2]);
    return new Root(gs, dataSectionConcat, ts, cst);
}
*/
start
    = line:(directive / section / instruction / comment / mcomment / blank_line)*

// Directivas en ARM64 v8
directive
  = _* name:directive_p _* args:(directive_p / label / string / expression)? _* comment? "\n"?

//
directive_p
    = "." directive_name

// Nombre de las directivas
directive_name
  = "align" / "ascii" / "asciz" / "byte" / "hword" / "word" / "quad" /
    "data" / "text" / "global" / "section" / "space" / "zero" / "incbin" / "set" / "equ" / "bss"

// Secciones
section
  = _* label:label _* ":" _* comment? "\n"?

// Instrucciones en ARM64 v8 
instruction
    = i:add_inst     {return i;}
    / i:sub_inst     {return i;}
    / i:mul_inst     {return i;}
    / i:div_inst     {return i;}
    / i:udiv_inst    {return i;}
    / i:uxtb_inst    {return i;}
    / i:sdiv_inst    {return i;}
    / i:ands_inst    {return i;}
    / i:and_inst     {return i;}
    / i:orr_inst     {return i;}
    / i:eor_inst     {return i;}
    / i:mov_inst     {return i;}
    / i:mvn_inst     {return i;}
    / i:ldr_inst     {return i;}
    / i:ldrb_inst    {return i;}
    / i:ldp_inst     {return i;}
    / i:strb_inst    {return i;}
    / i:str_inst     {return i;}
    / i:stp_inst     {return i;}
    / i:lsl_inst     {return i;}
    / i:lsr_inst     {return i;}
    / i:asr_inst     {return i;}
    / i:ror_inst     {return i;}
    / i:cmp_inst     {return i;}
    / i:csel_inst    {return i;}
    / i:cset_inst    {return i;}
    / i:beq_inst     {return i;}
    / i:bne_inst     {return i;}
    / i:bgt_inst     {return i;}
    / i:blt_inst     {return i;}
    / i:ble_inst     {return i;}
    / i:bl_inst      {return i;}
    / i:b_inst       {return i;}
    / i:ret_inst     {return i;}
    / i:svc_inst     {return i;}


// Instrucciones Suma 64 bits y 32 bits (ADD)
add_inst "Instrucción de Suma"
    = _* "ADD"i _* rd:reg64 _* "," _* src1:reg64 _* "," _* src2:operand64 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['add', rd, 'COMA', src1, 'COMA', src2]);
        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'add', rd.name, src1.name, src2.name, null);
    }

    / _* "ADD"i _* rd:reg32 _* "," _* src1:reg32 _* "," _* src2:operand32 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['add', rd, 'COMA', src1, 'COMA', src2]);
        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'add', rd.name, src1.name, src2.name, null);
    }

// Instruccions ands
ands_inst 'Instrucción de ands'
  = _* 'ANDS'i _* rd:reg64_or_reg32 ', ' rd1:reg64_or_reg32 ', ' rd2:immediate _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['ands', rd, 'COMA', rd1, 'COMA', rd2]);
        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'ands', rd.name, rd1.name, srd2.name, null);
    }

sub_inst 'Instrucción de resta'
    = _* 'SUB'i _* rd:reg64 ', ' rd1:reg64 ', ' rd2:operand64 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['sub', rd, 'COMA', rd1, 'COMA', rd2]);
        
        quads.push({ op: "SUB", dest: rd.name, arg1: rd1.name, arg2: rd2.name });

        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'sub', rd.name, rd1.name, rd2.name, null);
    }

    / _* 'SUB'i _* rd:reg32 ', ' rd1:reg32 ', ' rd2:operand32 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['sub', rd, 'COMA', rd1, 'COMA', rd2]);
        
        quads.push({ op: "SUB", dest: rd.name, arg1: rd1.name, arg2: rd2.name });

        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'sub', rd.name, rd1.name, rd2.name, null);
    }

// Instrucciones de Multiplicación 64 bits y 32 bits (MUL)
mul_inst
    = _* "MUL"i _* rd:reg64 _* "," _* src1:reg64 _* "," _* src2:operand64 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['mul', rd, 'COMA', src1, 'COMA', src2]);
        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'mul', rd.name, src1.name, src2.name, null);
    }

    / _* "MUL"i _* rd:reg32 _* "," _* src1:reg32 _* "," _* src2:operand32 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['mul', rd, 'COMA', src1, 'COMA', src2]);
        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'mul', rd.name, src1.name, src2.name, null);
    }

// Instrucciones de División 64 bits y 32 bits (DIV)
div_inst
    = _* "DIV"i _* rd:reg64 _* "," _* src1:reg64 _* "," _* src2:operand64 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['div', rd, 'COMA', src1, 'COMA', src2]);
        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'div', rd.name, src1.name, src2.name, null);
    }
    / _* "DIV"i _* rd:reg32 _* "," _* src1:reg32 _* "," _* src2:operand32 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['div', rd, 'COMA', src1, 'COMA', src2]);
        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'div', rd.name, src1.name, src2.name, null);
    }

// Instrucciones de División sin signo 64 bits y 32 bits (UDIV)
udiv_inst
    = _* "UDIV"i _* rd:reg64 _* "," _* src1:reg64 _* "," _* src2:operand64 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['udiv', rd, 'COMA', src1, 'COMA', src2]);
        
       // quads.push({ op: "UDIV", dest: rd.name, arg1: src1.name, arg2: src2.name });

        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'udiv', rd.name, src1.name, src2.name, null);
    }

    / _* "UDIV"i _* rd:reg32 _* "," _* src1:reg32 _* "," _* src2:operand32 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['udiv', rd, 'COMA', src1, 'COMA', src2]);
        
        //quads.push({ op: "UDIV", dest: rd.name, arg1: src1.name, arg2: src2.name });

        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'udiv', rd.name, src1.name, src2.name, null);
    }

// Instrucciones de División con signo 64 bits y 32 bits (SDIV)
sdiv_inst 
    = _* "SDIV"i _* rd:reg64 _* "," _* src1:reg64 _* "," _* src2:operand64 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['sdiv', rd, 'COMA', src1, 'COMA', src2]);
        
        //quads.push({ op: "SDIV", dest: rd.name, arg1: src1.name, arg2: src2.name });

        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'sdiv', rd.name, src1.name, src2.name, null);
    }

    / _* "SDIV"i _* rd:reg32 _* "," _* src1:reg32 _* "," _* src2:operand32 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['sdiv', rd, 'COMA', src1, 'COMA', src2]);
        
        //quads.push({ op: "SDIV", dest: rd.name, arg1: src1.name, arg2: src2.name });

        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'sdiv', rd.name, src1.name, src2.name, null);
    }

// Instrucciones AND 64 bits y 32 bits (AND)        
and_inst 'Instrucción AND'
    = _* "AND"i _* rd:reg64 _* "," _* src1:reg64 _* "," _* src2:operand64 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['and', rd, 'COMA', src1, 'COMA', src2]);
        
        //quads.push({ op: "AND", dest: rd.name, arg1: src1.name, arg2: src2.name });

        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'and', rd.name, src1.name, src2.name, null);
    }

    / _* "AND"i _* rd:reg32 _* "," _* src1:reg32 _* "," _* src2:operand32 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['and', rd, 'COMA', src1, 'COMA', src2]);
        
        //quads.push({ op: "AND", dest: rd.name, arg1: src1.name, arg2: src2.name });

        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'and', rd.name, src1.name, src2.name, null);
    }

// Instrucciones ORR 64 bits y 32 bits (ORR)
orr_inst 'Instrucción ORR'
    = _* "ORR"i _* rd:reg64 _* "," _* src1:reg64 _* "," _* src2:operand64 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['orr', rd, 'COMA', src1, 'COMA', src2]);
        
       //quads.push({ op: "ORR", dest: rd.name, arg1: src1.name, arg2: src2.name });

        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'orr', rd.name, src1.name, src2.name, null);
    }

    / _* "ORR"i _* rd:reg32 _* "," _* src1:reg32 _* "," _* src2:operand32 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['orr', rd, 'COMA', src1, 'COMA', src2]);
        
       // quads.push({ op: "ORR", dest: rd.name, arg1: src1.name, arg2: src2.name });

        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'orr', rd.name, src1.name, src2.name, null);
    }

// Instrucciones XOR 64 bits y 32 bits (EOR)
eor_inst 'Instrucción EOR'
    = _* "EOR"i _* rd:reg64 _* "," _* src1:reg64 _* "," _* src2:operand64 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['eor', rd, 'COMA', src1, 'COMA', src2]);
        
        //quads.push({ op: "EOR", dest: rd.name, arg1: src1.name, arg2: src2.name });

        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'eor', rd.name, src1.name, src2.name, null);
    }

    / _* "EOR"i _* rd:reg32 _* "," _* src1:reg32 _* "," _* src2:operand32 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Arithmetic', ['eor', rd, 'COMA', src1, 'COMA', src2]);
        
        //quads.push({ op: "EOR", dest: rd.name, arg1: src1.name, arg2: src2.name });

        return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'eor', rd.name, src1.name, src2.name, null);
    }


// Instrucción MOV 64 bits y 32 bits (MOV)
mov_inst "Instrucción MOV"
  = _* "MOV"i _* rd:reg64_or_reg32 _* "," _* src:mov_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Control', ['mov', rd, 'COMA', src]);
        return new Operation(loc?.line, loc?.column, idRoot, 'Control', 'mov', rd.name, src.name, null,null);
    }

reg64_or_reg32 "Registro de 64 o 32 Bits"
  = i:reg64             {return i;}
  / i:reg32             {return i;}

mov_source "Source para MOV"
  = i:reg64_or_reg32    {return i;}
  / i:immediate         {return i;}

//  Instucción Load Register (LDR)
// Instrucción Load Register (LDR)
ldr_inst "Instrucción LDR"
    = _* "LDR"i _* rd:reg64 _* "," _* src:ldr_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Load', ['ldr', rd, 'COMA', src]);
        
        //quads.push({ op: "LDR", dest: rd.name, arg1: src });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Load', 'ldr', rd.name, src, null, null);
    }

    / _* "LDR"i _* rd:reg32 _* "," _* src:ldr_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Load', ['ldr', rd, 'COMA', src]);
        
        //quads.push({ op: "LDR", dest: rd.name, arg1: src });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Load', 'ldr', rd.name, src, null, null);
    }

ldr_source 
    = "=" l:label
    {
        return l;
    }

    / "[" _* r:reg64_or_reg32 _* "," _* r2:reg64_or_reg32 _* "," _* s:shift_op _* i2:immediate _* "]"
    {
        return { base: r.name, offset: r2.name, shift: s, imm: i2 };
    }

    / "[" _* r:reg64 _* "," _* i:immediate _* "," _* s:shift_op _* i2:immediate _* "]"
    {
        return { base: r.name, offset: i, shift: s, imm: i2 };
    }

    / "[" _* r:reg64 _* "," _* i:immediate _* "," _* e:extend_op _* "]" 
    {
        return { base: r.name, offset: i, extend: e };
    }

    / "[" _* r:reg64 _* "," _* i:immediate _* "]"
    {
        return { base: r.name, offset: i };
    }

    / "[" _* r:reg64 _* "]"
    {
        return { base: r.name };
    }



// Instrucción Load Register (LDRB)
ldrb_inst "Instrucción LDRB"
    = _* "LDRB"i _* rd:reg64 _* "," _* src:ldr_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Load', ['ldrb', rd, 'COMA', src]);
        
        //quads.push({ op: "LDRB", dest: rd.name, arg1: src });
        //
        return new Operation(loc?.line, loc?.column, idRoot, 'Load', 'ldrb', rd.name, src, null, null);
    }

    / _* "LDRB"i _* rd:reg32 _* "," _* src:ldr_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Load', ['ldrb', rd, 'COMA', src]);
        
        //quads.push({ op: "LDRB", dest: rd.name, arg1: src });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Load', 'ldrb', rd.name, src, null, null);
    }

// Instrucción Load Pair Register (LDP)
ldp_inst "Instrucción LDP"
    = _* "LDP"i _* rd:reg64 _* "," _* rd2:reg64 _* "," _* src:ldr_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Load', ['ldp', rd, 'COMA', rd2, 'COMA', src]);
        
        //quads.push({ op: "LDP", dest1: rd.name, dest2: rd2.name, arg1: src });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Load', 'ldp', rd.name, rd2.name, src, null);
    }

    / _* "LDP"i _* rd:reg32 _* "," _* rd2:reg32 _* "," _* src:ldr_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Load', ['ldp', rd, 'COMA', rd2, 'COMA', src]);
        
        //quads.push({ op: "LDP", dest1: rd.name, dest2: rd2.name, arg1: src });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Load', 'ldp', rd.name, rd2.name, src, null);
    }

// Instrucción Store Register (STR)
str_inst "Instrucción STR"
    = _* "STR"i _* rd:reg64 _* "," _* src:str_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Store', ['str', rd, 'COMA', src]);
        
        //quads.push({ op: "STR", dest: src, arg1: rd.name });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Store', 'str', src, rd.name, null, null);
    }

    / _* "STR"i _* rd:reg32 _* "," _* src:str_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Store', ['str', rd, 'COMA', src]);
        
        //quads.push({ op: "STR", dest: src, arg1: rd.name });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Store', 'str', src, rd.name, null, null);
    }

str_source 
    = "[" _* r:reg64_or_reg32 _* "," _* r2:reg64_or_reg32 _* "," _* s:shift_op _* i2:immediate _* "]"
    {
        return { base: r.name, offset: r2.name, shift: s, imm: i2 };
    }

    / "[" _* r:reg64 _* "," _* i:immediate _* "," _* s:shift_op _* i2:immediate _* "]"
    {
        return { base: r.name, offset: i, shift: s, imm: i2 };
    }

    / "[" _* r:reg64 _* "," _* i:immediate _* "," _* e:extend_op _* "]"
    {
        return { base: r.name, offset: i, extend: e };
    }

    / "[" _* r:reg64 _* "," _* i:immediate _* "]"
    {
        return { base: r.name, offset: i };
    }

    / "[" _* r:reg64 _* "]"
    {
        return { base: r.name };
    }
// Instrucción Store Register Byte (STRB)
strb_inst "Instrucción STRB"
    = _* "STRB"i _* rd:reg64 _* "," _* src:str_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Store', ['strb', rd, 'COMA', src]);
        
        //quads.push({ op: "STRB", dest: rd.name, src: src });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Store', 'strb', rd.name, src, null, null);
    }

    / _* "STRB"i _* rd:reg32 _* "," _* src:str_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Store', ['strb', rd, 'COMA', src]);
        
        //quads.push({ op: "STRB", dest: rd.name, src: src });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Store', 'strb', rd.name, src, null, null);
    }

// Instrucción Store Pair Register (STP)
stp_inst "Instrucción STP"
    = _* "STP"i _* rd:reg64 _* "," _* rd2:reg64 _* "," _* src:str_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Store', ['stp', rd, 'COMA', rd2, 'COMA', src]);
        
        //quads.push({ op: "STP", dest1: rd.name, dest2: rd2.name, src: src });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Store', 'stp', rd.name, rd2.name, src, null);
    }

    / _* "STP"i _* rd:reg32 _* "," _* rd2:reg32 _* "," _* src:str_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Store', ['stp', rd, 'COMA', rd2, 'COMA', src]);
        
        //quads.push({ op: "STP", dest1: rd.name, dest2: rd2.name, src: src });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Store', 'stp', rd.name, rd2.name, src, null);
    }

// Instrucción Move Not (MVN)
mvn_inst "Instrucción MVN"
    = _* "MVN"i _* rd:reg64 _* "," _* src:mov_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Move', ['mvn', rd, 'COMA', src]);
        
        //quads.push({ op: "MVN", dest: rd.name, src: src });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Move', 'mvn', rd.name, src, null, null);
    }

    / _* "MVN"i _* rd:reg32 _* "," _* src:mov_source _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Move', ['mvn', rd, 'COMA', src]);
        
        //quads.push({ op: "MVN", dest: rd.name, src: src });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Move', 'mvn', rd.name, src, null, null);
    }


// Instrucción Logial Shift Left (LSL)
lsl_inst "Instrucción LSL"
    = _* "LSL"i _* rd:reg64 _* "," _* src1:reg64 _* "," _* src2:operand64 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Shift', ['lsl', rd, 'COMA', src1, 'COMA', src2]);
        
        //quads.push({ op: "LSL", dest: rd.name, src1: src1.name, src2: src2.value });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Shift', 'lsl', rd.name, src1.name, src2.value, null);
    }

    / _* "LSL"i _* rd:reg32 _* "," _* src1:reg32 _* "," _* src2:operand32 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Shift', ['lsl', rd, 'COMA', src1, 'COMA', src2]);
        
        //quads.push({ op: "LSL", dest: rd.name, src1: src1.name, src2: src2.value });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Shift', 'lsl', rd.name, src1.name, src2.value, null);
    }

// Instrucción Logial Shift Right (LSR)
lsr_inst "Instrucción LSR"
    = _* "LSR"i _* rd:reg64 _* "," _* src1:reg64 _* "," _* src2:operand64 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Shift', ['lsr', rd, 'COMA', src1, 'COMA', src2]);
        
        //quads.push({ op: "LSR", dest: rd.name, src1: src1.name, src2: src2.value });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Shift', 'lsr', rd.name, src1.name, src2.value, null);
    }

    / _* "LSR"i _* rd:reg32 _* "," _* src1:reg32 _* "," _* src2:operand32 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Shift', ['lsr', rd, 'COMA', src1, 'COMA', src2]);
        
        //quads.push({ op: "LSR", dest: rd.name, src1: src1.name, src2: src2.value });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Shift', 'lsr', rd.name, src1.name, src2.value, null);
    }

// Instrucción Arithmetical Shift Right (ASR)
asr_inst "Instrucción ASR"
    = _* "ASR"i _* rd:reg64 _* "," _* src1:reg64 _* "," _* src2:operand64 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Shift', ['asr', rd, 'COMA', src1, 'COMA', src2]);
        
        //quads.push({ op: "ASR", dest: rd.name, src1: src1.name, src2: src2.value });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Shift', 'asr', rd.name, src1.name, src2.value, null);
    }

    / _* "ASR"i _* rd:reg32 _* "," _* src1:reg32 _* "," _* src2:operand32 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Shift', ['asr', rd, 'COMA', src1, 'COMA', src2]);
        
        //quads.push({ op: "ASR", dest: rd.name, src1: src1.name, src2: src2.value });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Shift', 'asr', rd.name, src1.name, src2.value, null);
    }


// Instrucción Rotate Right (ROR)
ror_inst "Instrucción ROR"
    = _* "ROR"i _* rd:reg64 _* "," _* src1:reg64 _* "," _* src2:operand64 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Shift', ['ror', rd, 'COMA', src1, 'COMA', src2]);
        
       // quads.push({ op: "ROR", dest: rd.name, src1: src1.name, src2: src2.value });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Shift', 'ror', rd.name, src1.name, src2.value, null);
    }

    / _* "ROR"i _* rd:reg32 _* "," _* src1:reg32 _* "," _* src2:operand32 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Shift', ['ror', rd, 'COMA', src1, 'COMA', src2]);
        
       // quads.push({ op: "ROR", dest: rd.name, src1: src1.name, src2: src2.value });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Shift', 'ror', rd.name, src1.name, src2.value, null);
    }

// Instrucción Compare (CMP)
cmp_inst "Instrucción CMP"
    = _* "CMP"i _* src1:reg64 _* "," _* src2:operand64 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Compare', ['cmp', src1, 'COMA', src2]);
        
       // quads.push({ op: "CMP", src1: src1.name, src2: src2.value });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Compare', 'cmp', null, src1.name, src2.value);
    }

    / _* "CMP"i _* src1:reg32 _* "," _* src2:operand32 _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Compare', ['cmp', src1, 'COMA', src2]);
        
        //quads.push({ op: "CMP", src1: src1.name, src2: src2.value });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Compare', 'cmp', null, src1.name, src2.value);
    }

// Instrucción registro (CSEL)
csel_inst 'Instrucción CSEL'
    = _* 'CSEL'i _* rd:reg64 _* "," _* rn0:reg64_or_reg32 _* "," _* rn1:reg64_or_reg32 _* "," _* cond _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Conditional', ['csel', rd, 'COMA', rn0, 'COMA', rn1, 'COMA', cond]);
        
       // quads.push({ op: "CSEL", dest: rd.name, src1: rn0.name, src2: rn1.name, condition: cond });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Conditional', 'csel', rd.name, rn0.name, rn1.name, cond);
    }
    / _* 'CSEL'i _* rd:reg32 _* "," _* rn0:reg32 _* "," _* rn1:reg32 _* "," _* cond _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Conditional', ['csel', rd, 'COMA', rn0, 'COMA', rn1, 'COMA', cond]);
        
       // quads.push({ op: "CSEL", dest: rd.name, src1: rn0.name, src2: rn1.name, condition: cond });
        
        return new Operation(loc?.line, loc?.column, idRoot, 'Conditional', 'csel', rd.name, rn0.name, rn1.name, cond);
    }


// Instrucción de set (CSET)
cset_inst 
  = _* 'CSET'i _* rd:reg32 ', ' cond _* comment? "\n"?
  {
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Conditional', ['cset', rd, 'COMA', cond]);

    //quads.push({ op: "CSET", dest: rd.name, condition: cond });

    return new Operation(loc?.line, loc?.column, idRoot, 'Conditional', 'cset', rd.name, null, null, cond);
  }

// Instrucción Branch (B)
b_inst "Instrucción B"
    = _* "B"i _* l:label _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Branch', ['b', l]);

        //quads.push({ op: "B", label: l });

        return new Operation(loc?.line, loc?.column, idRoot, 'Branch', 'b', null, l, null);
    }

// Instrucción Branch with Link (BL)
bl_inst "Instrucción BL"
    = _* "BL"i _* l:label _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Branch', ['bl', l]);

       // quads.push({ op: "BL", label: l });

        return new Operation(loc?.line, loc?.column, idRoot, 'Branch', 'bl', null, l, null);
    }

// Instrucción Branch Less or Equal (BLE)
ble_inst "Instrucción BLE"
    = _* "BLE"i _* l:label _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Branch', ['ble', l]);

        //quads.push({ op: "BLE", label: l });

        return new Operation(loc?.line, loc?.column, idRoot, 'Branch', 'ble', null, l, null);
    }


// Instrucción Retornar de Subrutina (RET)
ret_inst "Instrucción RET"
    = _* "RET"i _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Return', ['ret']);

       // quads.push({ op: "RET" });

        return new Operation(loc?.line, loc?.column, idRoot, 'Return', 'ret', null, null, null);
    }

// Instrucción Salto Condicional (BEQ)
beq_inst "Instrucción BEQ"
    = _* "BEQ"i _* l:label _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Conditional Branch', ['beq', l]);

       // quads.push({ op: "BEQ", label: l });

        return new Operation(loc?.line, loc?.column, idRoot, 'Conditional Branch', 'beq', null, l, null);
    }

// Instrucción Salto Condicional (BNE)
bne_inst "Instrucción BNE"
    = _* "BNE"i _* l:label _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Conditional Branch', ['bne', l]);

       // quads.push({ op: "BNE", label: l });

        return new Operation(loc?.line, loc?.column, idRoot, 'Conditional Branch', 'bne', null, l, null);
    }

// Instrucción Salto Condicional (BGT)
bgt_inst "Instrucción BGT"
    = _* "BGT"i _* l:label _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Conditional Branch', ['bgt', l]);

        //quads.push({ op: "BGT", label: l });

        return new Operation(loc?.line, loc?.column, idRoot, 'Conditional Branch', 'bgt', null, l, null);
    }

// Instrucción Salto Condicional (BLT)
blt_inst "Instrucción BLT"
    = _* "BLT"i _* l:label _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Conditional Branch', ['blt', l]);

        //quads.push({ op: "BLT", label: l });

        return new Operation(loc?.line, loc?.column, idRoot, 'Conditional Branch', 'blt', null, l, null);
    }

// Instrucción Supervisor Call (SVC)
svc_inst "Instrucción SVC"
    = _* "SVC"i _* i:immediate _* comment? "\n"?
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Supervisor Call', ['svc', i]);

        //quads.push({ op: "SVC", immediate: i });

        return new Operation(loc?.line, loc?.column, idRoot, 'Supervisor Call', 'svc', null, null, i);
    }

// Instrucción de (UTXB)
uxtb_inst 'Instrucción UXTB'
    = _* 'UXTB'i _* i64:reg64 ',' _* i32:reg32
    {
        const loc = location()?.start;
        const idRoot = cst.newNode();
        newPath(idRoot, 'Instruction', ['uxtb', i64, i32]);

        //quads.push({ op: "UXTB", reg64: i64, reg32: i32 });

        return new Operation(loc?.line, loc?.column, idRoot, 'Instruction', 'uxtb', i64.name, i32.name, null);
    }


// Registros de propósito general 64 bits (limitado a los registros válidos de ARM64)
reg64 "Registro_64_Bits"
    = "x"i ("30" / [12][0-9] / [0-9])
    {
        let idRoot = cst.newNode(); 
        newPath(idRoot, 'register', [text()]);
        return { id: idRoot, name: text() }
    }
    / "SP"i // Stack Pointer
        
    / "LR"i  // Link Register

    / "ZR"i  // Zero Register

// Registros de propósito general 32 bits (limitado a los registros válidos de ARM64)
reg32 "Registro_32_Bits"
    = "w"i ("30" / [12][0-9] / [0-9])
    {
        let idRoot = cst.newNode(); 
        newPath(idRoot, 'register', [text()]);
        return { id: idRoot, name: text() }
    }
// Operando puede ser un registro o un número inmediato
operand64 "Operandor 64 Bits"
    = r:reg64 _* "," _* ep:extend_op                 // Registro con extensión de tamaño

    / r:reg64 lp:(_* "," _* shift_op _* immediate)?  // Registro con desplazamiento lógico opcional
  
    / i:immediate                                     // Valor inmediato                          

// Operando puede ser un registro o un número inmediato
operand32 "Operandor 32 Bits"
    = r:reg32 lp:(_* "," _* shift_op _* immediate)?  // Registro con desplazamiento lógico

    / i:immediate                             // Valor inmediato


// Definición de desplazamientos
shift_op "Operador de Desplazamiento"
    = "LSL"i

    / "LSR"i

    / "ASR"i

// Definición de extensiones
extend_op "Operador de Extensión"
    = "UXTB"i

    / "UXTH"i 

    / "UXTW"i 

    / "UXTX"i
 
    / "SXTB"i

    / "SXTH"i

    / "SXTW"i 

    / "SXTX"i
// condicional 
cond 'condicional_csel'
  = 'eq'i / 'ne'i / 'gt'i / 'ge'i / 'lt'i / 'le'i / 'hi'i / 'ls'i 

// Definición de valores inmediatos
immediate "Inmediato"
    =  "#"? "0b" int:binary_literal {return int;}

    / "#"? "0x" hex_literal

    / "#"? int:integer {return int; }

    / "#"? "'" le:letter "'" {return le;}

binary_literal 
  = [01]+ {return parseInt(text(), 2);} // Representa uno o más dígitos binarios
hex_literal
    = [0-9a-fA-F]+ // Representa uno o más dígitos hexadecimales
letter
    = [a-zA-Z] {return text();}

// Expresiones
expression "Espresión"
    = i:label {return i;}
    / i:integer {return i;}

// Etiqueta
label "Etiqueta"
    = id:[a-zA-Z_][a-zA-Z0-9_]*
    {
      let completeId = id[0]+id[1]?.join('');
      return completeId; 
    }

// Número entero
integer "Numero Entero"
    = '-'? [0-9]+  {return parseInt(text(), 10);}

// Cadena ASCII
string "Cadena de Texto"
    = '"' ([^"]*) '"' {return text();}

// Línea en blanco
blank_line "Linea En Blanco"
    = _* comment? "\n"{}


// Comentarios
comment "Comentario"
    = ("//" [^\n]*) {}
	/ (";" [^\n]*)  {}


mcomment "Comentario Multilinea"
    = "/*" ([^*] / [*]+ [^*/])* "*/" {}

// Espacios en blanco
_ "Ignorado"
    = [ \t]+ {}
