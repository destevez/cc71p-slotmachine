package cc71p.slotmachine.aspect;

import cc71p.slotmachine.face.InterfazHardware;
import cc71p.slotmachine.face.UIDebug;
/**
 * Aspecto Debug que captura todo proceso de logging de la Slot Machine
 * 
 * @author daniel
 *
 */
public aspect Debug {
	UIDebug ui;
	/** 
	 * Advice que captura el UI del aspecto Debug
	 */
	after(UIDebug ui):this(ui)&&execution(UIDebug+.new(..)){
		this.ui=ui;
		ui.printDialogBox("iniciado dialog box..");
	}
	
	/**
	 * Advice que captura toda la información de errores del dialog box de 
	 * la interfaz de hardware y la redirige a la propia UI
	 * 
	 */
	void around(InterfazHardware iH, String s):target(iH)&&
		args(s)&&call(void InterfazHardware.printDialogBox(String))
	&&cflow(call(void InterfazHardware.fail()))
	{
		ui.printDialogBox(s);	 		
	};


}
