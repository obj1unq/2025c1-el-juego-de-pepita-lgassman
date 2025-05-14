import wollok.game.*
import pepita.*


class Visual {
    method atravesable() {
        return true
    }
}

object nido inherits Visual {
    const position = game.at(7,8)

    method position () {
        return position
    }

    method image(){
        return "nido.png"
    }

    method colision(ave) {
        ave.cambiarEstado(ganadora)
    }


}

object silvestre inherits Visual {

    var property presa = pepita

    method image(){
        return "silvestre.png"
    }

    method position(){
        return game.at(self.xLimitado(), 0)  
    }

    method xLimitado(){
        return 3.max(presa.xPosicion())
    }

    method colision(ave) {
        ave.cambiarEstado(atrapada)
    }

}

class Muro inherits Visual {

    method image() = "muro.png"
    const property position = game.origin()

    override method atravesable() {
        return false
    }

}