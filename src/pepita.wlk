import wollok.game.*
import extras.*

object pepita {
	var energia = 100
	var position = game.at(8, 2)
	var property destino = nido
	var property cazador = silvestre
	
	method comer(comida) {
		energia += comida.energiaQueOtorga()
	}

	method volar(kms) {
		energia = energia - 8 - kms
	}
	
	method position() = position
	
	method position(_position) {
		position = _position
	}
	
	method energia() = energia
	
	method image() = ("pepita-" + self.estado()) + ".png"

	method text() { //RGBA (opcional)
		return energia.toString()
	}

	method textColor() {
		return "FF0000FF" //RGBA (opcional)
	}
	
	method estado()  {
		return if (self.enDestino()) {
				"destino"
			} else {
				if (self.atrapada()) { 
					"atrapada" 
				} else { 
					"afuera"
				}
			}
	}
	
	method atrapada() = self.position() == cazador.position()
	
	method enDestino() = self.position() == destino.position()

	method moverArriba() {
		self.volar(1)
		position = game.at(position.x(), position.y() + 1)
	}
	method moverAbajo() {
		self.volar(1)
		position = game.at(position.x(), position.y() - 1)
	}
	method moverDerecha() {
		self.volar(1)
		position = game.at(position.x()+1, position.y())
	}

	method moverIzquierda() {
		self.volar(1)
		position = game.at(position.x()-1, position.y())
	}

}