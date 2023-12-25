package de.ts.eclipsestore.apiservice.store;

import jakarta.annotation.PostConstruct;
import java.util.Date;
import org.eclipse.store.storage.embedded.types.*;
import org.springframework.stereotype.Service;

@Service
public class StorageRoot {

	@PostConstruct
	void postConstruct() {
		// Initialize a storage manager ("the database") with purely defaults.
		final EmbeddedStorageManager storageManager = EmbeddedStorage.start();

		// print the last loaded root instance,
		// replace it with a current version and store it
		System.out.println(storageManager.root());
		storageManager.setRoot("Hello World! @ " + new Date());
		storageManager.storeRoot();

		// shutdown storage
		storageManager.shutdown();
	}
}
