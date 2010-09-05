package cc71p.slotmachine.aspect;

import cc71p.slotmachine.Reel;
import cc71p.slotmachine.SlotMachine;
import cc71p.slotmachine.face.InterfazHardware;
/**
 * Aspecto Demo utilizado para simular acciones durante la ejecución de la SlotMachine
 * @author daniel
 *
 */
public aspect Demo {
	
	private InterfazHardware iH;
	
	/**
	 * Simula la impresión de texto en la UI independiente del aspecto Demo
	 * 
	 * @param s Texto a imprimir
	 */
	private void printUIDemo(String s){
		System.out.println("+++++++++++++DEMO+++++++++++++++++");
		System.out.println(s);
		System.out.println("++++++++++++++++++++++++++++++++++");
	}

	/**
	 * Simular insertar dinero
	 */
	private int creditos_a_simular=50;
	/**
	 * 
	 * Advice que simula inserción de dinero justo después de crear la
	 * interfaz de hardware en el slot machine. 
	 * 
	 * Adicionalmente captura en el
	 * aspecto la interfaz para su posible uso futuro
	 * 
	 * @param sM slot machine que crea interfaz de hardware
	 * @param iH interfaz de hardware
	 */
	after(SlotMachine sM) returning (InterfazHardware iH):
		  args(sM, ..) && call(InterfazHardware+.new(..)) {
		       this.iH = iH;
		       this.iH.insert(creditos_a_simular);
		       this.printUIDemo("Insertados "+creditos_a_simular+ " créditos");
	}
	/**
	 * Preestablecer resultados del juego
	 * 
	 * indiceReel lleva el indice del reel a reemplazar
	 * resultadoReel es el resultado que los reel tengan en orden de forma ciclica
	 */
	private int indiceReel=0;
	private int[]resultadoReel={0};
	/**
	 * Advice que reemplaza los valores del spin de cada reel por uno predeterminado
	 * 
	 * @param reel Reel que se gira
	 * @param value valor original que iba a tener debido al giro
	 */
	void around (Reel reel, int value):
		 call (void Reel.spin(int))
		  && target(reel) && args (value) {
			boolean vA= reel.locked;
			reel.locked=false;
			int spin= resultadoReel[indiceReel++];			
			reel.locked=vA;
			printUIDemo("reemplazado valor de spin por "+spin);
			if(indiceReel>resultadoReel.length-1)
				indiceReel=0;
			reel.value=spin;
		return;
	};
	/**
	 * Simular fallas de hardware
	 * 
	 * probabilidad de falla
	 */
	private double probabilidad_de_falla=1.0;
	/**
	 * PointCut que captura los metodos de la clase Interfaz Hardware
	 * 
	 * @param iH objeto InterfazHardware para ser capturado en la ejecución de un metodo
	 */
	pointcut IHMethod(InterfazHardware iH):
		this(iH) && execution(* *(..)) &&
		  !cflow(execution(void fail()));

	/**
	 * Advice que dada una probabilidad de falla establece si se ejecuta una falla (boton fail)
	 * en la interfaz o no. No se establece consecuencia de falla por lo que no se realiza
	 * nada más aparte de avisar la falla.
	 * 
	 * @param iH Interfaz de Hardware que se verifica
	 */
	before (InterfazHardware iH):IHMethod(iH){
			double azar= Math.random();
			if(probabilidad_de_falla>=azar){
				printUIDemo("simulada falla de hardware");
				iH.fail();
			}
	};	

}
