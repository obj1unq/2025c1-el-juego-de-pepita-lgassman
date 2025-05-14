import wollok.game.*
import randomizer.*

object comidas {

	const todas = #{}

	method configurar() {
		game.onTick(3000, self.nombreEventoNuevaComida(), {self.nuevaComida()})
		game.onTick(5000, self.nombreEventoPasoTiempo(),  {self.pasarTiempo()})

	}

	method nombreEventoNuevaComida() {
		return "comidas"
	}

	method nombreEventoPasoTiempo() {
		return "tick"
	}
	method pasarTiempo() {
		todas.forEach( { alimento => alimento.tick() })
	}

	method nuevaComida() {
		const comida = new Manzana(position = randomizer.emptyPosition())
		game.addVisual(comida)
		todas.add(comida)
	}
	method remover(comida) {
		todas.remove(comida)
		game.removeVisual(comida)
	}
}

class Alimento {
	method colision(ave) {
        ave.comer(self)
		comidas.remover(self)
    }

	method energiaQueOtorga() 

	method text() {
		return self.energiaQueOtorga().toString()
	}
	method textColor() {
		return "00FF00FF"
	}

	method tick() {

	}

}

class Manzana inherits Alimento {
	var property position = game.origin()
	const base= 5
	var madurez = 1
	
	method image(){
		return "manzana.png"
	}

	override method energiaQueOtorga() {
		return base * madurez	
	}
	
	method madurar() {
		madurez = madurez + 1
		//madurez += 1
	}

	override method tick() {
		self.madurar()
	}


}

class Alpiste inherits Alimento {
	var property position = game.origin()

	method image(){
		return "alpiste.png"
	}

	override method energiaQueOtorga() {
		return 20
	} 

}
