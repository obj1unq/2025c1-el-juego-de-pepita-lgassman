import wollok.game.*
import randomizer.*
import extras.*

object comidas {

	const todas = #{}
	const factories = [manzanaFactory, alpisteFactory]

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
		const comida = self.construirComida()
		game.addVisual(comida)
		todas.add(comida)
	}
	method remover(comida) {
		todas.remove(comida)
		game.removeVisual(comida)
	}

	method construirComida() {
		return factories.anyOne().nueva()
	}
}

object manzanaFactory {
	method nueva() {
		return new Manzana(position = randomizer.emptyPosition())
	}
}
object alpisteFactory {
	method nueva() {
		return new Alpiste(position = randomizer.emptyPosition(), peso = (1..20).anyOne() )
	}

}

class Alimento inherits Visual {
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
	const peso = 20

	method image(){
		return "alpiste.png"
	}

	override method energiaQueOtorga() {
		return peso
	} 

}
