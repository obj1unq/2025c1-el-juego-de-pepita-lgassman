import wollok.game.*
object arriba{
    method siguientePosicion(position){
        return game.at(position.x(), position.y() + 1)
    }
}

object abajo{
    method siguientePosicion(position){
        return game.at(position.x(), position.y() - 1)
    }
}

object derecha{
    method siguientePosicion(position){
        return game.at(position.x() + 1, position.y())
    }
}

object izquierda{
    method siguientePosicion(position){
        return game.at(position.x() - 1, position.y())
    }
}