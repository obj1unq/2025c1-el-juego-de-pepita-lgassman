import wollok.game.*
import randomizer.*
import extras.*

object manzanaFactory {

	method crear() {
		return new Manzana(position = randomizer.emptyPosition())
	}
}

object alpisteFactory {
	method crear() {
		return new Alpiste(position = randomizer.emptyPosition(), peso = (1 .. 20).anyOne() )
	}
}

object comidas {

	const factories = [manzanaFactory, alpisteFactory]
	const alimentos = #{}
	const maximo = 3

	method configurar() {
		game.onTick(3000, self.nombreEventoCreacionComida(), {self.nuevaComida()})
		game.onTick(7000, self.nombreEventoPasoTiempo(), {self.pasarTiempo()})
	}

	method nombreEventoPasoTiempo() {
		return "pasaElTiempo"
	}

	method nombreEventoCreacionComida() {
		return "nuevaComida"
	}

	method pasarTiempo() {
		alimentos.forEach({alimento => alimento.pasarTiempo()})
	}

	method nuevaComida() {
		if (alimentos.size() < maximo) {
			const comida = self.crearComida()
			game.addVisual(comida)
			alimentos.add(comida)
		}
	}

	method remover(comida) {
		alimentos.remove(comida)
		game.removeVisual(comida)
	}

	method crearComida() {
		return factories.anyOne().crear()
	}

}

class Alimento inherits Visual {
	const property position = game.origin()
	method image()
	method energiaQueOtorga()
	
	method colision(ave) {
		ave.comer(self)
		comidas.remover(self)
	}

	method text() {
		return self.energiaQueOtorga().toString()
	}

	method textColor() {
		return "00FF00FF"
	}

	method pasarTiempo() {
	}
}

class Manzana inherits Alimento {
	const base= 5
	var madurez = 1
	
	override method image(){
		return "manzana.png"
	}

	override method energiaQueOtorga() {
		return base * madurez	
	}
	
	method madurar() {
		madurez = madurez + 1
		//madurez += 1
	}

	override method pasarTiempo() {
		self.madurar()
	}

	
}

class Alpiste inherits Alimento{
	const peso = 20

	override method image(){
		return "alpiste.png"
	}

	override method energiaQueOtorga() {
		return peso
	} 

}
