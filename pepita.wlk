import wollok.game.*
import extras.*
import direcciones.*
import comidas.*

object nivel{	
	method configurarTablero(){
		game.title("Pepita") 	//Valor por defecto "Wollok Game"
		game.height(10) 		//valor por defecto 5
		game.width(10) 			//valor por defecto 5
		game.cellSize(50) 		//valor por defecto 50
		//search assets in assets folder, for example, for the background
		//game.ground("fondo.jpg") //Este pone la imagen de fondo en cada celda.
		game.boardGround("fondo.jpg")
	}

	method finalizar(){
		self.removerGravedad()
		game.schedule(2000, { game.stop() })
	}

	method configurar(){
		game.onTick(800,self.nombreEventoGravedad(), { pepita.aplicarGravedad()}) //` para agregar gravedad, haciendo que pepita pierda altura cada 800
		comidas.configurar()
	}

	method removerGravedad() {
		game.removeTickEvent(self.nombreEventoGravedad())
	}
	method nombreEventoGravedad() {
		return "gravedad" + self.identity()
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
	var position = game.at(0, 2)
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
		energia -= self.energiaNecesaria(kms)
	}
	
	method position() = position
	
	method position(_position) {
		position = _position
	}
	
	method energia() = energia
	
	method image() = "pepita-" + estado.nombreImagen() + ".png"

	method validarVolar(distancia){
		if(not self.puedeVolar()){
			self.error("No puede volar!")
		}
	}

	method xPosicion(){
		return position.x()
	}

	method puedeVolar() {
		return energia >= self.energiaNecesaria(1)
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
		self.validarMover(direccion)
		self.volar(1)
		position = direccion.siguientePosicion(position)
		if(not self.puedeVolar()){
			self.cambiarEstado(debil)
		}	
	}

	method validarMover(direccion){
		estado.validarMover(self, direccion)
	}

	method estado(_estado){
		estado = _estado
	}

	method energiaNecesaria(kms){
		return 8 + kms
	}

	method finalizar(){
		game.say(self, estado.mensaje())
		nivel.finalizar()
	}

	method aplicarGravedad(){
		const siguiente = abajo.siguientePosicion(position)
		if(nivel.existe(siguiente)){
			position = abajo.siguientePosicion(position)
		}
	}

	method cambiarEstado(_estado) {
		estado = _estado
		estado.progresar(self)
	}

}

class Estado {
	method nombreImagen()
	method mensaje()

	method progresar(ave){
		ave.finalizar()
	}
	method puedeMover(ave) {
		return false
	}
	
	method validarMover(ave, direccion){
		if (not self.puedeMover(ave) )
			ave.error(self.mensaje())
	}


}


object afuera inherits Estado{

	override method nombreImagen(){
		return "afuera"
	}

	override method progresar(ave){
	}

	override method validarMover(ave, direccion){
		super(ave, direccion)
		const destino = direccion.siguientePosicion(ave.position())
		if (not nivel.existe(destino)) {
			ave.error("No voy a salir de la pantalla")
		}
	}



	override method puedeMover(ave){
		return ave.puedeVolar() 
	}

	override method mensaje(){
		return "Todo bien"
	}


}

object ganadora inherits Estado{
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

	override method mensaje(){
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