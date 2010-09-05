package cc71p.slotmachine.aspect;

import cc71p.slotmachine.face.DialogBox;
/**
 * Aspecto Debug que captura todo proceso de logging de la Slot Machine
 * 
 * @author daniel
 *
 */
public aspect Debug {
	/**
	 * Advice que captura toda la información del dialog box, no deja que 
	 * se despliegue en el dialog box y la despliega donde estime necesario
	 * 
	 * @param dB dialog box que emite mensaje
	 * @param dialog mensaje del dialog box
	 */
	void around (DialogBox dB, String dialog):
		 call (void DialogBox.print(String))
		  && target(dB) && args (dialog) {
			printUIDebug(dialog);
		return;
	};
	
	/**
	 * Método que representa el imprimir texto en la UI independiente del aspecto
	 * Debug
	 * 
	 * @param s texto a imprimir
	 */
	private void printUIDebug(String s){
		System.out.println("++++++++++++DEBUG+++++++++++++++++");
		System.out.println(s);
		System.out.println("++++++++++++++++++++++++++++++++++");
	}
	


}
