
object avion {
  var property vida = 3 
  var property position = new MutablePosition(x=0,y=8)
  var property enemigosEliminados = 0
  var property puntaje = 0
  const imamgenBalaPersonaje = "spaceMissiles_015.png"

  method image() = "cuphead.png"

  method hablar() = "Bienvenidos a mi juego..." 

  method decirVida() = self.vida()

  method decirPuntos() = self.puntaje()

  method sumarPuntaje(enemigo){puntaje+=enemigo.puntaje()}
  
  method perderVida(x) {
    vida -= 1             //Hay que aplicarle como minimo 0
    if(self.vida() == 0){
      game.removeVisual(self)
      game.addVisual(fondoFinJuego2)
      game.addVisual(fondoFinDelJuego)
      game.addVisual(finDelJuego)
      //sonidoGameOver.reproducirSonido()
    }
  }

  method disparar()  {
  const nuevaBala = new Bala(latitud=self.position().x(), altura =self.position().y() , imagen = imamgenBalaPersonaje, id = 0.randomUpTo(5000), esEnemigo=false)
  game.addVisual(nuevaBala)
	game.onTick(100,"disparo"+nuevaBala.id(),{nuevaBala.moveteDerecha()})
	game.whenCollideDo(nuevaBala, {elemento => 
  elemento.perderVida(nuevaBala)
  })
	}
                     
}

class Corazon {
  const id
  
  method esCuerpoACuerpo() = false
  method image() = "heart_21 (2).png"
  method position() = new MutablePosition(x=id,y=9)
  method desaparecer() =  game.removeVisual(self)
  method perderVida(x){}            // lo entiende pero no hace nada
  method colicionarContraAvion(){}  // lo entiende pero no hace nada
}

object fondoFinDelJuego {

  method position() = new MutablePosition(x=1,y=0)

  method image() = "gameOver.png"
  
}

object fondoFinJuego2{
  method position() = new MutablePosition(x=0,y=0)

  method image() = "finDelJuego.png"
}

object paleta {
  const property rojo = "FF0000FF"
}

object finDelJuego {

  method position() = game.center()

  method text() = "Puntaje obtenido: " + avion.puntaje().toString()

  method textColor() = paleta.rojo()

  method perderVida(x){}  // lo entiende pero no hace nada
}

/*object bossFinal {
  var property puntaje = 100
  method esCuerpoACuerpo() = false
  var property esBala = false
  var property position = new MutablePosition(x=14,y=2)// mientras menos velocidad, el enemigo se desplaza mas rapido
  var property esEnemigo = true 
  var property vida = 5
  var property intervaloDisparo = 1500
  var property imagenBalaBoss = "spaceMissiles_024.png"
  var property velocidadDisparo = 1000
  
  method image()="Hilda_Berg_Moon_Sprite(1).png"
  
  method perderVida() { 
    vida -= 1
    if(self.vida()==0) {
      avion.sumarPuntaje(self)
      fase.sacarEnemigosVivos()
      fase.sumarEliminados(self)
      game.removeVisual(self)

    }
  }
    method disparar(){
    game.onTick(self.intervaloDisparo(), "disparoBoss", { 
      if(avion.estaVivo()){
      const nuevaBala = new Bala(latitud=self.position().x(), altura =0.randomUpTo(9)  , imagen=imagenBalaBoss, esEnemigo=true,id = 0.randomUpTo(5000) )
      game.addVisual(nuevaBala)
      game.onTick(self.velocidadDisparo(), "disparoBoss1"+nuevaBala.id(), { nuevaBala.moveteIzquierda() })
      const nuevaBala = new Bala(latitud=self.position().x(), altura =0.randomUpTo(9) , imagen=imagenBalaBoss, esEnemigo=true,id = 0.randomUpTo(5000) )
      game.addVisual(nuevaBala)
      game.onTick(self.velocidadDisparo(), "disparoBoss2"+nuevaBala.id(), { nuevaBala.moveteIzquierda() })
      const nuevaBala = new Bala(latitud=self.position().x(), altura =0.randomUpTo(9)  , imagen=imagenBalaBoss, esEnemigo=true,id = 0.randomUpTo(5000) )
      game.addVisual(nuevaBala)
      game.onTick(self.velocidadDisparo(), "disparoBoss3"+nuevaBala.id(), { nuevaBala.moveteIzquierda() })
      const nuevaBala = new Bala(latitud=self.position().x(), altura =0.randomUpTo(9)  , imagen=imagenBalaBoss, esEnemigo=true,id = 0.randomUpTo(5000) )
      game.addVisual(nuevaBala)
      game.onTick(self.velocidadDisparo(), "disparoBoss4"+nuevaBala.id(), { nuevaBala.moveteIzquierda() })
      }
    }) 
    
  }
}*/

//object sonidoGameOver {
//  method reproducirSonido(){
//    game.sound("water-drop-sound.mp3").play()
//  }
//}

class EnemigoCuerpoACuerpo {
  var property puntaje = 5
  var property position = new MutablePosition(x=19,y=0.randomUpTo(10))   // Para que arranque en alguna posicion del borde
  var property velocidad = 1000     // mientras menos velocidad, el enemigo se desplaza mas rapido
  var property vida = 5
  var property id 

  method cambiarVelocidad() {velocidad = 100.max(velocidad-50)} //Hay que pensar un minimo (pensamos 100)

  method image() = "alienQueSeMueve.png"

  method colicionarContraAvion() {self.reaparecerAlaDerecha() avion.perderVida(id)}

  method reaparecerAlaDerecha() {position = new MutablePosition(x=18,y=0.randomUpTo(10))}

  method despalzamiento(){
    game.onTick(self.velocidad(), "movimiento"+self.id(), { self.movete() })
  }

  method movete(){  // se desplaza uno para la izquierda
    position.goLeft(1)

    if(position.x() < 0) {
      self.reaparecerAlaDerecha()
    }
  }
  
  method perderVida(nuevaBala) { 
    vida -= 1
    if(self.vida()==0) {
      avion.sumarPuntaje(self)
      fase.sacarEnemigosVivos()
      fase.sumarEliminados(self)
      game.removeTickEvent("movimiento"+self.id())
      game.removeVisual(self)
    }
    nuevaBala.eliminarBala()
  }
}


class EnemigoPistolero {
  const imagenBalaPistolero = "bala_Enemigo.png"
  var property position = game.at(17,0.randomUpTo(10))   // Para que arranque en alguna posicion del borde
  var property vida = 3
  var property intervaloDisparo = 2000      // mientras menos, el intervalo entre cada bala es mas rapido
  var property velocidadDisparo = 250       // mientras menos, la velocidad de las balas es mas rapida
  var property puntaje = 7
  var property id 

  
  method cambiarIntervaloDisparo() {intervaloDisparo = 1000.max(intervaloDisparo-100)} //Hay que pensar un minimo (pensamos 100)

  method cambiarVelocidadDisparo() {velocidadDisparo = 100.max(velocidadDisparo-25)}

  method colicionarContraAvion() {avion.perderVida(id)}
  
  method image() = "alienQueDispara.png"

  method disparar(){
    
    game.onTick(self.intervaloDisparo(), "disparoEnemigo1"+self.id(), { 
      if(avion.vida()>0){
      const nuevaBala = new Bala(latitud=self.position().x(), altura =self.position().y() , imagen=imagenBalaPistolero,id = 0.randomUpTo(5000), esEnemigo=true)
      game.addVisual(nuevaBala)
      game.onTick(self.velocidadDisparo(), "disparoEnemigo2"+nuevaBala.id(), { nuevaBala.moveteIzquierda() })
      }
    }) 
    
  }

  method perderVida(nuevaBala) { 
    vida -= 1
    if(self.vida()==0) {
      avion.sumarPuntaje(self)
      fase.sacarEnemigosVivos()
      fase.sumarEliminados(self)
      game.removeTickEvent("disparoEnemigo1"+self.id())
      game.removeVisual(self)
    }
    nuevaBala.eliminarBala()
  }

}


class Bala {
  var property latitud
  var property altura
  var property position = new MutablePosition(x=latitud,y=altura)
  var property imagen  
  var property id 
  const esEnemigo 

  method image() = imagen

  method perderVida(nuevaBala) {} // lo entiende pero no hace nada

  method vida () = 3

  method eliminarBala(){
    position = new MutablePosition(x=100,y=100)
    game.removeTickEvent("disparo"+self.id())
    game.removeVisual(self)
  }
  method moveteDerecha() {
    if(position.x() < 20) {
      position.goRight(1)
    }
    else {
      self.eliminarBala()
    }
  }

  method moveteIzquierda(){
    if(position.x() > 0) {
      position.goLeft(1)
    }
    else {
      game.removeTickEvent("disparoEnemigo2"+self.id())
      game.removeVisual(self)
    }
  }
  method colicionarContraAvion() {
    if(esEnemigo){
      avion.perderVida(id)
    }
    game.removeTickEvent("disparoEnemigo2"+self.id())
		game.removeVisual(self)
  }

}

object fase {
  var property tiempoAparicion = 4000 //miliseg
  var property maxEnemigos = 4 
  var property enemigosVivos = 0
  var property nroFase = 1
  var property eliminacionesCambioFase = 6
  var property enemigosEliminadosFase = 0


  method sumarEliminado() {
    enemigosEliminadosFase += 1
  }

  method reiniciarEliminados(){
    enemigosEliminadosFase = 0
  }
  
  method sumarEliminados(enemigo){
  
      self.sumarEliminado()
    
  } 
  
  method cambiarFase() { 
    if(nroFase < 3){
      nroFase += 1
      self.reiniciarEliminados()
    }
    else {
      self.cambiarTiempoAparicion()
      self.cambiarEnemigosMax()

      EnemigoCuerpoACuerpo.cambiarVelocidad()
      EnemigoPistolero.cambiarIntervaloDisparo()
      EnemigoPistolero.cambiarVelocidadDisparo()

      nroFase = 1

    }

  }

  method cambiarTiempoAparicion() {
    if(tiempoAparicion > 1000) tiempoAparicion -= 1000
  }
  
  method cambiarEnemigosMax(){
    if(maxEnemigos<12) maxEnemigos += 3
  }
  
  method agregarCuerpoACuerpo () {
    if ((nroFase == 1 or nroFase==3) and avion.vida()>0){ //Usar contador de vida 
    const nuevoEnemigoCuerpo = new EnemigoCuerpoACuerpo(id = 0.randomUpTo(5000))
    game.addVisual(nuevoEnemigoCuerpo)
    self.sumarEnemigosVivos()
    nuevoEnemigoCuerpo.despalzamiento()
    }

  }

  method agregarPistolero (){ //el ovni 
    if ((nroFase == 2 or nroFase==3) and avion.vida()>0){
    const nuevoEnemigoPistolero = new EnemigoPistolero(id = 0.randomUpTo(5000))
    game.addVisual(nuevoEnemigoPistolero)
    self.sumarEnemigosVivos()
    nuevoEnemigoPistolero.disparar()
  }
  }

  /*method agregarBoss (){
    if(nroFase == 4 and avion.estaVivo()){
      game.addVisual(bossFinal)
      bossFinal.disparar()
      self.sumarEnemigosVivos()
    }
  }*/

  method sumarEnemigosVivos() { 
    enemigosVivos += 1
  }

  method sacarEnemigosVivos() {
    enemigosVivos -= 1
  }
  
}