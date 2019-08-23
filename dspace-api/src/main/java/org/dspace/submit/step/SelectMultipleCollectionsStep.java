/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.submit.step;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dspace.app.util.SubmissionInfo;
import org.dspace.app.util.Util;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Collection;
import org.dspace.content.Item;
import org.dspace.content.WorkspaceItem;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.WorkspaceItemService;
import org.dspace.core.Context;
import org.dspace.submit.AbstractProcessingStep;

/**
 * SelectCollection Step which processes the collection that the user selected
 * in that step of the DSpace Submission process
 * <P>
 * This class performs all the behind-the-scenes processing that
 * this particular step requires.  This class's methods are utilized 
 * by both the JSP-UI and the Manakin XML-UI
 * 
 * @see org.dspace.app.util.SubmissionConfig
 * @see org.dspace.app.util.SubmissionStepConfig
 * @see org.dspace.submit.AbstractProcessingStep
 * 
 * @author Tim Donohue
 * @version $Revision$
 */
public class SelectMultipleCollectionsStep extends AbstractProcessingStep
{
    /***************************************************************************
     * STATUS / ERROR FLAGS (returned by doProcessing() if an error occurs or
     * additional user interaction may be required)
     * 
     * (Do NOT use status of 0, since it corresponds to STATUS_COMPLETE flag
     * defined in the JSPStepManager class)
     **************************************************************************/
    // no collection was selected
    public static final int STATUS_NO_COLLECTION = 1;

    // invalid collection or error finding collection
    public static final int STATUS_INVALID_COLLECTION = 2;

    protected WorkspaceItemService workspaceItemService = ContentServiceFactory.getInstance().getWorkspaceItemService();

    /**
     * Do any processing of the information input by the user, and/or perform
     * step processing (if no user interaction required)
     * <P>
     * It is this method's job to save any data to the underlying database, as
     * necessary, and return error messages (if any) which can then be processed
     * by the appropriate user interface (JSP-UI or XML-UI)
     * <P>
     * NOTE: If this step is a non-interactive step (i.e. requires no UI), then
     * it should perform *all* of its processing in this method!
     * 
     * @param context
     *            current DSpace context
     * @param request
     *            current servlet request object
     * @param response
     *            current servlet response object
     * @param subInfo
     *            submission info object
     * @return Status or error flag which will be processed by
     *         doPostProcessing() below! (if STATUS_COMPLETE or 0 is returned,
     *         no errors occurred!)
     */
    @Override
    public int doProcessing(Context context, HttpServletRequest request,
            HttpServletResponse response, SubmissionInfo subInfo)
            throws ServletException, IOException, SQLException,
            AuthorizeException
    {
        // First we find the collection which was selected
        UUID owningCollectionId = subInfo.getSubmissionItem().getCollection().getID();
	List<UUID> selectedIds = Util.getUUIDParameters(request, "mapped_collections[]");

        // if the user didn't select a collection,
        // it's ok. just continue to the next step; 
        if (selectedIds == null)
        {
            return STATUS_COMPLETE;
        }

        // test each of the newly selected collections
	for(UUID id : selectedIds) {
		if(id == owningCollectionId) continue;

		Collection col = collectionService.find(context, id);

		// Show an error if the collection is invalid
		if (col == null)
		{
		    return STATUS_INVALID_COLLECTION;
		}
	}
	
	Item item = subInfo.getSubmissionItem().getItem();

	// we need to check for every collection previously associated with this item first. 
	List<Collection> previousCollections = item.getCollections();
	for(Collection pcol : previousCollections) {
		if( pcol.getID() != owningCollectionId && !selectedIds.contains(pcol.getID()) ) {
			// if it doesn't appear in the UUID list, and is not the owning collection,
			//  it's not a valid collection for this item anymore. So remove it.
			collectionService.removeItem(context, pcol, item);
		}
	}

	// assign each collections to the item
	for(UUID id : selectedIds) {
		Collection col = collectionService.find(context, id); 
		collectionService.addItem(context, col, item);
	}


        // commit changes to database
        context.dispatchEvents();

	// TODO later: probably we need to clear mapped collections if collection is changed. 
	// just like how this part of the code clear out submission config
	// this has to be done in the "selectCollectionStep" instead of here
	    //
            // need to reload current submission process config,
            // since it is based on the Collection selected
            //  subInfo.reloadSubmissionConfig(request);

        // no errors occurred
        return STATUS_COMPLETE;
    }

    /**
     * Retrieves the number of pages that this "step" extends over. This method
     * is used to build the progress bar.
     * <P>
     * This method may just return 1 for most steps (since most steps consist of
     * a single page). But, it should return a number greater than 1 for any
     * "step" which spans across a number of HTML pages. For example, the
     * configurable "Describe" step (configured using input-forms.xml) overrides
     * this method to return the number of pages that are defined by its
     * configuration file.
     * <P>
     * Steps which are non-interactive (i.e. they do not display an interface to
     * the user) should return a value of 1, so that they are only processed
     * once!
     * 
     * @param request
     *            The HTTP Request
     * @param subInfo
     *            The current submission information object
     * 
     * @return the number of pages in this step
     */
    @Override
    public int getNumberOfPages(HttpServletRequest request,
            SubmissionInfo subInfo) throws ServletException
    {
        // there is always just one page in this step!
        return 1;
    }
}
