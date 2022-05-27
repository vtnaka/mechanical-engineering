from tkinter import *
import tkinter.ttk as ttk
import numpy as np
import matplotlib.pyplot as plt

main = Tk()

def getDados():

    # Tensões normais
    sx1 = float(sx.get())
    sy1 = float(sy.get())
    sz1 = float(sz.get())

    # Tensões tangenciais
    txy1 = float(txy.get())
    txz1 = float(txz.get())
    tyz1 = float(tyz.get())

    # Matriz
    mat = np.matrix([[sx1, txy1, txy1], [txy1, sy1, tyz1], [txz1, tyz1, sz1]])

    # Invariantes
    i1 = sx1 + sy1 + sz1
    i2 = (sx1*sy1)+(sx1*sz1)+(sz1*sy1)-(txy1**2)-(txz1**2)-(tyz1**2)
    i3 = np.linalg.det(mat)

    # Valores das tensões principais e tangencial máxima
    sp = np.roots([1, -i1, i2, -i3])

    sp.sort()

    s1.insert(0, round(sp[2], 4))
    s2.insert(0, round(sp[1], 4))
    s3.insert(0, round(sp[0], 4))

    tmax.insert(0,round((sp[2]-sp[0])/2, 4))

    # Círculos de Mohr
    # Sigma 1 e 3
    theta = np.linspace(0, 2*np.pi, 100)
    oc1 = round((sp[2]+sp[0])/2, 4)
    r1 = round((sp[2]-sp[0])/2, 4)
    x1 = (r1*np.cos(theta))+oc1
    x2 = r1*np.sin(theta)

    # Sigma 1 e 2
    oc2 = round((sp[2]+sp[1])/2, 4)
    r2 = round((sp[2]-sp[1])/2, 4)
    x3 = (r2*np.cos(theta))+oc2
    x4 = r2*np.sin(theta)

    # Sigma 2 e 3
    oc3 = round((sp[1]+sp[0])/2, 4)
    r3 = round((sp[1]-sp[0])/2, 4)
    x5 = (r3*np.cos(theta))+oc3
    x6 = r3*np.sin(theta)

    # Criar gráfico
    fig, ax = plt.subplots(1)
    ax.plot(x1, x2, label='_nolegend_')
    ax.plot(x3, x4, label='_nolegend_')
    ax.plot(x5, x6, label='_nolegend_')
    ax.plot(sp[2], 0, 'ro', label='\u03c3\u2081 = %.4f' %(sp[2]))
    ax.plot(sp[1], 0, 'bv', label='\u03c3\u2082 = %.4f' %(sp[1]))
    ax.plot(sp[0], 0, 'g^', label='\u03c3\u2083 = %.4f' %(sp[0]))
    ax.plot(oc1, r1, 'ks', label='\u03c4\u2098 = %.4f' %(r1))
    ax.set_aspect(1)
    ax.legend()
    plt.xlabel('\u03c3')
    plt.ylabel('\u03c4')
    plt.gca().legend(loc='center left', bbox_to_anchor=(1, 0.5))
    plt.grid()
    plt.show()


# Propriedades da janela
main.title("Estado Triplo de Tensões")
main.geometry("350x500")
main.resizable(False, False)
main.iconbitmap('icon2.ico')
main.configure(background="#dde")

# Título
Label(main, text="Tensões do ponto em análise", background="#dde", anchor="w", font=(None, 12, 'bold')).place(x=10, y=10, width=300, height=20)

# Tensões normais
Label(main, text="Tensão normal do plano x", background="#dde", anchor="w").place(x=10, y=40, width=200, height=20)
sx = Entry(main)
sx.place(x=10, y=60, width=75, height=20)

Label(main, text="Tensão normal do plano y", background="#dde", anchor="w").place(x=10, y=110, width=200, height=20)
sy = Entry(main)
sy.place(x=10, y=130, width=75, height=20)

Label(main, text="Tensão normal do plano z", background="#dde", anchor="w").place(x=10, y=170, width=200, height=20)
sz = Entry(main)
sz.place(x=10, y=190, width=75, height=20)

# Tensões tangenciais
Label(main, text="Tensão transversal xy", background="#dde", anchor="w").place(x=200, y=40, width=200, height=20)
txy = Entry(main)
txy.place(x=200, y=70, width=75, height=20)

Label(main, text="Tensão transversal xz", background="#dde", anchor="w").place(x=200, y=110, width=200, height=20)
txz = Entry(main)
txz.place(x=200, y=130, width=75, height=20)

Label(main, text="Tensão transversal yz", background="#dde", anchor="w").place(x=200, y=170, width=200, height=20)
tyz = Entry(main)
tyz.place(x=200, y=190, width=75, height=20)

# Armazenar os valores nas variáveis da função getDados
Button(main, text="Submeter", command=getDados).place(x=125, y=230, width=100, height=25)

# Separador
ttk.Separator(main).place(x=0, y=265, relwidth=1)

# Título dos resultados
Label(main, text="Resultados da análise", background="#dde", anchor="w", font=(None, 12, 'bold')).place(x=10, y=280, width=300, height=20)

# Exibir tensões normais principais e tensão tangencial máxima
Label(main, text="Tensão principal 1", background="#dde", anchor="w").place(x=10, y=320, width=100, height=20)
s1 = Entry(main)
s1.place(x=10, y=340, width=75, height=20)

Label(main, text="Tensão principal 2", background="#dde", anchor="w").place(x=10, y=380, width=100, height=20)
s2 = Entry(main)
s2.place(x=10, y=400, width=75, height=20)

Label(main, text="Tensão principal 3", background="#dde", anchor="w").place(x=10, y=440, width=100, height=20)
s3 = Entry(main)
s3.place(x=10, y=460, width=75, height=20)

Label(main, text="Tensão máxima tangencial", background="#dde", anchor="w").place(x=200, y=320, width=150, height=20)
tmax = Entry(main)
tmax.place(x=200, y=340, width=75, height=20)

main.mainloop()