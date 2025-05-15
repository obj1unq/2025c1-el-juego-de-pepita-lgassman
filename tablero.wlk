import pepita.*
import extras.*
import comidas.*

object _ {
    method construir(posicion) {

    }
}

object p {
    method construir(posicion) {
        pepita.position(posicion)
    }

}
object m {
    method construir(posicion) {
        game.addVisual( new Muro(position=posicion))
    }
}
object M {
    method construir(posicion) {
        game.addVisual( new Muro(position=posicion))
        game.addVisual( new Manzana(position=posicion))
    }
}

object n {
    method construir(posicion) {
        nido.position(posicion)
        game.addVisual(nido)
    }

}
object s {
    method construir(posicion) {
        game.addVisual(silvestre)
    }

}

object tablero {

    const mapa = [
        [_,_,_,_,_,_,_,m,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,_,_,_,_,m,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,_,_,_,_,m,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,_,_,_,_,m,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,_,_,_,_,m,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,_,_,_,_,m,n,_,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,_,_,_,_,m,m,m,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,_,m,m,m,m,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,p,_,_,m,m,m,m,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,_,m,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,_,m,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,s,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]
    ].reverse()

    method configurar() {
		game.title("Pepita") 	//Valor por defecto "Wollok Game"
		game.height(mapa.size()) 		//valor por defecto 5
		game.width(mapa.anyOne().size()) 			//valor por defecto 5
		game.cellSize(50) 		//valor por defecto 50
		//search assets in assets folder, for example, for the background
		//game.ground("fondo.jpg") //Este pone la imagen de fondo en cada celda.
		game.boardGround("fondo.jpg")

        (0 .. game.width() - 1).forEach({x =>  
            (0 .. game.height() - 1).forEach( {y => 
                const constructor = mapa.get(y).get(x)
                constructor.construir(game.at(x, y))
            })
        })
        game.addVisual(pepita)



	}
}