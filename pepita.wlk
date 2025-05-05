import wollok.game.*
import extras.*
import direcciones.*
import comidas.*

object nivel{
	const comidas = #{alpiste, manzana} 
	
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
		game.schedule(2000, { game.stop() })
	}

	method configurar(){
		comidas.forEach({ comida => comida.configurar()})
		game.onTick(800,"gravedad" + pepita.identity(), { pepita.aplicarGravedad()}) //` para agregar gravedad, haciendo que pepita pierda altura cada 800
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
	var energia = 100
	var position = game.at(8, 2)
	var property destino = nido
	var property cazador = silvestre
	var estado = afuera
	
	method comerEnLugar(){
		const cosaEnPosicion = self.cosaEnPosicion()
		
		self.comer(cosaEnPosicion)
		cosaEnPosicion.cambiarPosicion()
    }
	
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
		return true
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
		estado.actualizar(self)	
	}

	method validarMover(direccion){
		if(not self.puedeMover(direccion)){
			self.error(estado.mensaje() + " o está fuera del mapa!")
		}
	}

	method puedeMover(direccion){
		return estado.puedeMover() && nivel.existe(direccion.siguientePosicion(position))
	}

	method esDebil(){
		return energia <= 0
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
}

object afuera{
	method nombreImagen(){
		return "afuera"
	}

	method actualizar(ave){
		if(ave.enDestino()){
			ave.estado(ganadora)
		} else { 
			self.verSidebilOAtrapada(ave)
		}
		ave.progresar()
	}

	method progresar(ave){

	}

	method puedeMover(){
		return true
	}

	method verSidebilOAtrapada(ave){
		if(ave.esDebil()){
			ave.estado(debil)
		} else {
			self.verSiAtrapada(ave)
		}
	}

	method verSiAtrapada(ave){
		if(ave.atrapada()){
			ave.estado(atrapada)
		}
	}
}

object ganadora{
	method nombreImagen(){
		return "destino"
	}

	method puedeMover(){
		return false
	}	

	method mensaje(){
		return "Ya gané!!!"
	}

	method progresar(ave){
		ave.finalizar()	
	}
}

object atrapada{
	method nombreImagen(){
		return "gris"
	}

	method puedeMover(){
		return true //false?
	}	

	method actualizar(ave){
		if(ave.esDebil()){
			ave.estado(debil)
		} else {
			self.comprobarLibertad(ave)
		}
	}

	method comprobarLibertad(ave){
		if(not ave.atrapada()){
			ave.estado(afuera)
		}
	}

}

object debil{
	method nombreImagen(){
		return "gris"
	}

	method puedeMover(){
		return false
	}	

	method mensaje(){
		return "Estoy debil!!!"
	}

	method progresar(ave){
		ave.finalizar()	
	}
}