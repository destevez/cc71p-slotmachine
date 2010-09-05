package cc71p.slotmachine.face;

import java.io.BufferedReader;
import java.io.InputStreamReader;
/**
 * Clase utilizada en la Interfaz ejecutable para el ingreso de comandos para el
 * manejo de la Slot Machine
 * 
 * @author daniel
 *
 */
public class InputBox {
	/**
	 * Obtiene una linea desde el teclado
	 * 
	 * @return texto ingresado mediante el teclado
	 */
	public String getLine() {
		   String aLine = "";
		   BufferedReader input = 
		     new BufferedReader(new InputStreamReader(System.in));
		   
		   try {
		     aLine = input.readLine();
		   }
		   catch (Exception e) {
		     e.printStackTrace();
		   }
		   return aLine;
		  }

}
