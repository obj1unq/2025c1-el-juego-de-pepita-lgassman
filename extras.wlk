import wollok.game.*
import pepita.*
object nido {
    const position = game.at(7,8)

    method position () {
        return position
    }

    method image(){
        return "nido.png"
    }

}

object silvestre{

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

}