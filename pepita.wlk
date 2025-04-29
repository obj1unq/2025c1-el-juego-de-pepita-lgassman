import wollok.game.*
import extras.*
import direcciones.*

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

	method textColor() {
		return "FF0000FF" //RGBA (opcional)
	}
	
	method atrapada() = self.position() == cazador.position()
	
	method enDestino() = self.position() == destino.position()

	method mover(direccion){
		//self.error(estado.mensajeMover())
		if(self.puedeMover()){
			self.validarMover(direccion)
			self.volar(1)
			position = direccion.siguientePosicion(position)
			estado.actualizar(self)	
		}
		
	}

	method validarMover(direccion){
		if(not self.puedeMover()){
			self.error(estado.mensajeMover())
		}
	}

	method puedeMover(){
		return estado.puedeMover()
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

	method mensajeMover(){
		return "Ya gané!!!"
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

	method mensajeMover(){
		return "Estoy debil!!!"
	}
}