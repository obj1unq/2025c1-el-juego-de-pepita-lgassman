import wollok.game.*
import randomizer.*

object manzana {
	var property position = game.origin()
	const base= 5
	var madurez = 1
	
	method image(){
		return "manzana.png"
	}

	method energiaQueOtorga() {
		return base * madurez	
	}
	
	method madurar() {
		madurez = madurez + 1
		//madurez += 1
	}

	method configurar(){
		self.cambiarPosicion()
		game.addVisual(self)
	}

	method cambiarPosicion(){
		position = randomizer.emptyPosition()
		self.madurar()
	}

}

object alpiste {
	var property position = game.origin()

	method image(){
		return "alpiste.png"
	}

	method energiaQueOtorga() {
		return 20
	} 

	method configurar(){
		self.cambiarPosicion()
		game.addVisual(self)
	}

	method cambiarPosicion(){
		position = randomizer.emptyPosition()
	}

}
