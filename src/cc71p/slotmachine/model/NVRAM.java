package cc71p.slotmachine.model;


import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.Enumeration;
import java.util.Hashtable;
/**
 * 
 * <b>Clase contenedor de metodos para implementar persistencia de objetos
 * en disco duro</b>
 * 
 *
 * 28-09-2010 - (Daniel Estévez G.): versión inicial  
 *
 */
public class NVRAM {
	public Hashtable<Object, Object> _ram = new Hashtable<Object, Object>();
	private String filename = "NVRAM.ser";
	
	public void doSave(){
        System.out.println();
        System.out.println("+------------------------------+");
        System.out.println("| doSave Method                |");
        System.out.println("+------------------------------+");
        System.out.println();
       
    
		try {
            System.out.println("Creating File/Object output stream...");           
            FileOutputStream fileOut = new FileOutputStream(filename);
            ObjectOutputStream out = new ObjectOutputStream(fileOut);

            System.out.println("Writing Hashtable Object...");
            out.writeObject(_ram);

            System.out.println("Closing all output streams...\n");
            out.close();
            fileOut.close();
           
        } catch(FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
	}
	
	public void doLoad() {

        System.out.println();
        System.out.println("+------------------------------+");
        System.out.println("| doLoad Method                |");
        System.out.println("+------------------------------+");
        System.out.println();
       
    


        try {

            System.out.println("Creating File/Object input stream...");
           
            FileInputStream fileIn = new FileInputStream(filename);
            ObjectInputStream in = new ObjectInputStream(fileIn);

            System.out.println("Loading Hashtable Object...");
            _ram = (Hashtable)in.readObject();

            System.out.println("Closing all input streams...\n");
            in.close();
            fileIn.close();
           
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch(FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.println("Printing out loaded elements...");
        for (Enumeration e = _ram.keys(); e.hasMoreElements(); ) {
            Object obj = e.nextElement();
            System.out.println("  - Element(" + obj + ") = " + _ram.get(obj));
        }
        System.out.println();

    }
}
