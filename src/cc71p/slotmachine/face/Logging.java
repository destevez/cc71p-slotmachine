package cc71p.slotmachine.face;

import java.util.Calendar;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;
/**
 * 
 * <b>Clase que implementa interfaz de logging</b>
 * 
 *
 * 03-10-2010 - (Daniel Estévez G.): versión inicial  
 *
 */
public class Logging{
	Text dialogBox;
	Display display;
	boolean isLogging;
	private int dialogWidth=800,dialogHeight=600;
	/**
	 * 
	 * @param shell shell de SWT para abrir ventana independiente
	 * @param isLogging true para activar logging local, false en caso contrario
	 */
	public Logging(Shell shell,boolean isLogging) {
		this.isLogging=isLogging;
		shell.setText("Logging UI");
		display=shell.getDisplay();
		int x=0,y=0;
		shell.setSize(dialogWidth, dialogHeight);	
		dialogBox = new Text(shell, SWT.MULTI|SWT.BORDER | SWT.H_SCROLL | SWT.V_SCROLL);
		dialogBox.setSize(dialogWidth-20, dialogHeight-40);
		dialogBox.setLocation(x, y);
		
	}	
	
	public void log(String[]elements){
		for(String e:elements){
			printDialogBox(e);
		}
	}
	
	/**
	 * 
	 * Imprime en la dialog box un mensaje manteniendo los mensajes anteriores
	 * 
	 * Hace un append en la parte superior de la dialog box
	 * 
	 *
	 * 19-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param s texto a agregar
	 */
	public void printDialogBox(final String s){
		Thread t= new Thread(){
			public void run() {
				String texto = dialogBox.getText();
				texto=Calendar.getInstance().getTime()+"-"+s+"\n"+texto;
				dialogBox.setText(texto);
			};
		};
		display.asyncExec(t);
		
	}
}
