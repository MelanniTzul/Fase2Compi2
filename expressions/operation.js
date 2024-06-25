class Operation extends Expression {

    constructor(line, col, id, name, inst, op1, op2, op3, op4,gen) {
        super();
        this.line = line;
        this.col = col;
        this.id = id;
        this.gen = gen;
        this.name = name;
        this.inst = inst;
        this.op1 = op1;
        this.op2 = op2;
        this.op3 = op3;
        this.op4 = op4;
        gen.addQuadruple(this.inst, this.op2, this.op3, null, this.op1);
    }

}