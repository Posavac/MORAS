def _parse_macros(self):
    lines = []
    i = 0

    firstOpenWhile = 0
    openWhile = False
        
    for (line, _, n) in self._lines:
        if (line[0] != '$'):
            lines.append((line, i, n))
            i += 1
            continue
        
        macroLines = self._expand_macro(line, n)

        if (not self._flag):
            self._line = n
            return
        if (len(self._macroLabelStack) > 0 and (not openWhile)):
            openWhile = True
            firstOpenWhile = n
        elif (len(self._macroLabelStack) == 0):
            openWhile = False
            self._macroEndCnt = 0
        
        for l in macroLines.split():
            if (len(l) == 0): 
                continue
            lines.append((l, i, n))
            i += 1
    
    if len(self._macroLabelStack) > 0:
        self._flag = False
        self._errm = "Macro \"WHILE\" has no \"END\"."
        self._line = firstOpenWhile

    self._lines = lines

def _expand_macro(self, line, n):
    l = line[1:].split('(')
    #print(l)
    try:
        opcode = l[0]    
    except:
        self._flag = False
        self._errm = "Invalid macro."
        return

    if not (opcode in self._macros):
        self._flag = False
        self._errm = "Unknown macro."
        print(opcode)
        return

    var = []
    try:
        if (opcode == "END"):
            if (len(l) > 1):
                raise Exception()
        elif (l[1][-1] != ')'):
            raise Exception()
        else:
            var = l[1][:-1].split(',')
        
            if (var[-1] == ''):
                raise Exception()
    except:
        self._flag = False
        self._errm = "Invalid macro syntax."
        return
    #print(var)


    if (len(var) > self._macros[opcode][0]):
        self._flag = False
        self._errm = "Too many macro arguments."
        return

    fullMacro = self._macros[opcode][1]
    
    if (opcode == "WHILE"):
        var.insert(0, "__LABEL_MACRO_" + str(self._macroLabelCnt) + "_END")
        var.insert(0, "__LABEL_MACRO_" + str(self._macroLabelCnt) + "_BEGIN")
        self._macroLabelStack.append(self._macroLabelCnt)
        self._macroLabelCnt += 1
    elif (opcode == "END"):
        try:
            labelNum = self._macroLabelStack.pop()
            var.insert(0, "__LABEL_MACRO_" + str(labelNum) + "_END")
            var.insert(0, "__LABEL_MACRO_" + str(labelNum) + "_BEGIN")
        except:
            self._flag = False
            self._line = n
            self._errm = "Macro \"END\" has no \"WHILE\"."
            return
    elif (opcode == "SETD"):
        val = int(var[0])
        var = [abs(val), 'A' if val >= 0 else '-A']


    return fullMacro.format(*var)

def _parse_symbols(self):
    # Inicijalizacija predefiniranih oznaka.
    self._init_symbols()
    
    # Prvo parsiramo deklaracije oznaka. Npr. "(LOOP)".
    self._iter_lines(self._parse_labels)

    # Na kraju parsiramo varijable i reference na oznake te ih pretvaramo u
    # konstante. Npr. "@SCREEN" pretvaramo u "@16384" ili "@END" kojemu je
    # oznaka "(END)" bila u trecoj liniji pretvaramo u "@3".
    self._n = 16
    self._iter_lines(self._parse_variables)

# Svaka oznaka mora biti sadrzana unutar oblih zagrada. Npr. "(LOOP)". Svaka
# oznaka koju procitamo treba zapamtiti broj linije u kojoj se nalazi i biti
# izbrisana iz nje. Koristimo dictionary _labels.

def _parse_labels(self, line, p, o):
    if line[0] != "(":
        return line
    else:
        label = line[1:].split(")")[0]
        if len(label) == 0:
            self._flag = False
            self._line = o
            self._errm = "Invalid label"
        else:
            self._labels[label] = str(p)
            
    return ""

# Svaki poziv na varijablu ili oznaku je oblika "@NAZIV", gdje naziv nije broj.
# Prvo provjeriti oznake ("_labels"), a potom varijable ("_vars"). Varijablama
# dodjeljujemo memorijske adrese pocevsi od 16. Ova funkcija nikad ne vraca
# prazan string!
def _parse_variables(self, line, p, o):
    if line[0] != "@":
        return line

    l = line[1:]

    if l.isdigit():
        return line

    if l in self._labels.keys():
        return "@" + self._labels[l]
    elif l in self._variables.keys():
        return "@" + self._variables[l]
    else:
        self._variables[l] = str(self._n)
        self._n += 1
        return "@" + str(self._n - 1)

# Inicijalizacija predefiniranih oznaka.
def _init_symbols(self):
    self._labels = {
        "SCREEN" : "16384",
        "KBD" : "24576",
        "SP" : "0",
        "LCL" : "1",
        "ARG" : "2",
        "THIS" : "3",
        "THAT" : "4"
    }
    self._macros = {
        "MV" : (2,"@{0}\nD=M\n@{1}\nM=D"),
        "SWP" : (2,"@{1}\nD=M\n@__MACRO_SWP_TEMP\nM=D\n@{0}\nD=M\n@{1}\nM=D\n@__MACRO_SWP_TEMP\nD=M\n@{0}\nM=D"),
        "SUM" : (3,"@{0}\nD=M\n@{1}\nD=D+M\n@{2}\nM=D"),
        "WHILE" : (1,"({0})\n@{2}\nD=M\n@{1}\nD;JEQ"),
        "END" : (0,"@{0}\n0;JMP\n({1})"),
        "SET" : (2,"@{0}\nD=A\n@{1}\nM=D"),
        "SWPREF" : (2,"@{1}\nA=M\nD=M\n@__MACRO_SWP_TEMP\nM=D\n@{0}\nA=M\nD=M\n@{1}\nA=M\nM=D\n@__MACRO_SWP_TEMP\nD=M\n@{0}\nA=M\nM=D"),
        "SETD" : (1,"@{0}\nD={1}")
    }
    
    for i in range(0, 16):
        self._labels["R" + str(i)] = str(i)
