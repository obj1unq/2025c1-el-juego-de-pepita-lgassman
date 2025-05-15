import wollok.game.*
import extras.*
import direcciones.*
import comidas.*

object nivel{
	

	method finalizar(){
		game.removeTickEvent(self.nombreEventoGravedad())
		game.schedule(2000, { game.stop() })
	}

	method nombreEventoGravedad() {
		return "gravedad" + self.identity()
	}

	method configurar(){
		game.onTick(800,self.nombreEventoGravedad(), { pepita.aplicarGravedad()}) //` para agregar gravedad, haciendo que pepita pierda altura cada 800
	}
	
			//nivel.existe(direccion.siguientePosicion(position))
	method puedeMover(personaje, posicion) {
		return self.existe(posicion) and self.puedeAtravesar(personaje, posicion)
	}

	method puedeAtravesar(personaje, posicion) {
		return game.getObjectsIn(posicion).copyWithout(personaje).all({visual => visual.atravesable()})
	}

	method existe(posicion)	{
		return self.existeX(posicion.x()) && self.existeY(posicion.y())
	}

	method enLimite(coord, max){
		return coord.between(0, max - 1) 
	}

	method existeX(x){
		return self.enLimite(x, game.width())
		// x >= 0 && x <= game.width() - 1
	} 

	method existeY(y){
		return self.enLimite(y, game.height())
		//y.between(0, game.height() - 1) 
		// x >= 0 && x <= game.width() - 1
	} 
}

object pepita {
	var energia = 300
	var position = game.at(1, 5)
	var property destino = nido
	var property cazador = silvestre
	var estado = afuera
		
	method comer(comida) {
		energia += comida.energiaQueOtorga()
	}

	method cosaEnPosicion(){
		return game.uniqueCollider(self)
	}

	method volar(kms) {
		self.validarVolar(1)
		energia -= self.energiaNecesaria(kms)
	}
	
	method position() = position
	
	method position(_position) {
		position = _position
	}
	
	method energia() = energia
	
	method image() = "pepita-" + estado.nombreImagen() + ".png"

	method validarVolar(distancia){
		if(not self.puedeVolar(distancia)){
			self.error("No puede volar!")
		}
	}

	method xPosicion(){
		return position.x()
	}

	method puedeVolar(distancia) {
		return energia >= self.energiaNecesaria(distancia)
	}

	method mensajeError(){ 
		return "" + 1 + "!"	
	}

	method text() { //RGBA (opcional)
		return energia.toString()
	}

	method progresar(){
		estado.progresar(self)
	}

	method textColor() {
		return "FF0000FF" //RGBA (opcional)
	}
	
	method atrapada() = self.position() == cazador.position()
	
	method enDestino() = self.position() == destino.position()

	method mover(direccion){
		//self.error(estado.mensajeMover())
		self.validarMover(direccion)
		self.volar(1)
		position = direccion.siguientePosicion(position)
		if (not self.puedeVolar(1)) {
			self.cambiarEstado(debil)
		}
	}

	method validarMover(direccion){
		if(not self.puedeMover(direccion)){
			self.error(estado.mensaje() + " o está fuera del mapa!")
		}
	}

	method puedeMover(direccion){
		return estado.puedeMover(self) && nivel.puedeMover(self, direccion.siguientePosicion(position))
	}

	method estado(_estado){
		estado = _estado
	}

	method cambiarEstado(_estado) {
		self.estado(_estado)
		estado.iniciar(self)
	}

	method energiaNecesaria(kms){
		return 8 + kms
	}

	method aplicarGravedad(){
		const siguiente = abajo.siguientePosicion(position)
		if(nivel.puedeMover(self, siguiente)){
			position = siguiente
		}
	}
}


class Estado {
	
	method nombreImagen()

	method puedeMover(ave){
		return false
	}	

	method mensaje()

	method iniciar(ave){
		game.say(self, self.mensaje())
		nivel.finalizar()
	}
}

object afuera inherits  Estado {
	
	override method nombreImagen(){
		return "afuera"
	}

	override method iniciar(ave){

	}

	override method puedeMover(ave){
		return ave.puedeVolar(1)
	}

	override method mensaje() {
		return "Comienza el juego"
	}
} 


object ganadora inherits Estado {
	override method nombreImagen(){
		return "destino"
	}

	override method mensaje(){
		return "Ya gané!!!"
	}

}

object atrapada inherits Estado {
	override method nombreImagen(){
		return "gris"
	}
	
	override method mensaje() {
		return "Me agarraron"
	}

}

object debil inherits Estado {
	override method nombreImagen(){
		return "gris"
	}


	override method mensaje(){
		return "Estoy debil!!!"
	}

}