/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.jsptag;

import org.apache.log4j.Logger;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.TreeMap;
import java.util.Set;
import java.util.TreeSet;
import java.util.Iterator;
import java.util.Collections;
// import java.util.ResourceBundle;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import org.dspace.app.webui.util.UIUtil;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.CommunityService;
import org.dspace.core.Context;
import org.dspace.core.LogManager;

/**
 * Renders select element to select collection with parent community
 * object.
 * 
 * @author Keiji Suzuki
 */
public class AccordCollectionTag extends TagSupport
{

	private static final Logger log = Logger.getLogger(AccordCollectionTag.class);

	private static final CommunityService communityService = ContentServiceFactory.getInstance().getCommunityService();
    /** the class description */
    private String klass;

    /** the name description */
    private String name;

    /** the id description */
    private String id;

    /** the collection id */
    private String collection = null;

    /** the community handle to be omitted **/
    private String omit = "123456789/1,123456789/637";

    private Boolean checkbox = false;
    private List<String> selectedCollections;
    private List<Collection> selectedCollectionsList;

    private String prefix = "accold";
    private String pHeading = prefix + "Heading";
    private String pBody = prefix + "Collapse";

    private int counter = 1;

    private static final String TOP = "top";

    public AccordCollectionTag()
    {
        super();
    }

    public int doStartTag() throws JspException
    {
        JspWriter out = pageContext.getOut();
        StringBuffer sb = new StringBuffer();

        try
        {
            HttpServletRequest hrq = (HttpServletRequest) pageContext.getRequest();
            Context context = UIUtil.obtainContext(hrq);
            List<Collection> collections = (List<Collection>) hrq.getAttribute("collections");
            List<Collection> selectedCollectionsList = (List<Collection>) hrq.getAttribute("selected.collections");
	    this.selectedCollectionsList = selectedCollectionsList;
	    selectedCollections = new ArrayList<String>();

	    if(selectedCollectionsList != null)
	    for(Collection col : selectedCollectionsList) {
		selectedCollections.add( col.getID().toString() );
	    }


	    // comMap[handle1] : Set of <handles> of (handle1)'s **sub-communities**
	    // colMap[handle1] : Set of <handles> of (handle1)'s **collections**
	    Map<String, Set<String> > comMap, colMap;
	    Map<String, String> titleMap;

	    comMap = new TreeMap<>();
	    colMap = new TreeMap<>();
	    titleMap = new HashMap<>();

	   for(Collection c : collections) {
		build(context, c, comMap, colMap, titleMap);
	   }

	    String ret = generate(TOP, counter, comMap, colMap, titleMap);
	    log.info( LogManager.getHeader(context, "accord_tag", "collectionID = " + this.collection) );

            out.print(ret);
        }
        catch (IOException e)
        {
            throw new JspException(e);
        }
        catch (SQLException e)
        {
            throw new JspException(e);
        }
        
        return SKIP_BODY;
    }

    public String getOmit()
    {
        return omit;
    }

    public void setOmit(String omit)
    {
        this.omit = omit;
    }

    public String getKlass()
    {
        return klass;
    }

    public void setKlass(String klass)
    {
        this.klass = klass;
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getId()
    {
        return id;
    }

    public void setId(String id)
    {
        this.id = id;
    }

    public String getCollection()
    {
        return collection;
    }

    public void setCollection(String collection)
    {
        this.collection = collection;
    }

    public Boolean getCheckbox() {
	return this.checkbox;
    }
    public void setCheckbox(Boolean bool) {
	this.checkbox = bool;
    }

    public List<String> getSelectedCollections() {
	    return this.selectedCollections;
    }

    public void setSelectedCollections(List<String> sc) {
	    this.selectedCollections = sc;
    }

    public void release()
    {
        klass = null;
        name = null;
        id = null;
        collection = null;
    }

    private void build(Context context, Collection c, Map<String, Set<String> > comMap, Map<String, Set<String> > colMap, Map<String, String> titleMap) throws SQLException {

	List<Community> ancestors = communityService.getAllParents(context, c);	
	Community parent = ancestors.get(0);
	Collections.reverse(ancestors);
	String prev = TOP;
	for(Community com : ancestors) {
		titleMap.putIfAbsent(com.getHandle(), com.getName());
		if(!comMap.containsKey(prev)) {
			Set s = new TreeSet<>();
			comMap.put(prev, s);
		}
		comMap.get(prev).add(com.getHandle());
		prev = com.getHandle();
	}


	if(!colMap.containsKey(parent.getHandle())) {
		Set s = new TreeSet<>();
		colMap.put(parent.getHandle(), s);
	}
	colMap.get(parent.getHandle()).add(c.getHandle());
	titleMap.put(c.getHandle(), c.getName());
	titleMap.put((String) "id-" + c.getHandle(), c.getID().toString());
	// log.info("INSIDE build : " + c.getName() + ", " + c.getHandle() + " | child of " + parent + ", " + parent.getHandle());
    }

    private String generate(String current, int parentCounter, Map<String, Set<String> > comMap, Map<String, Set<String> > colMap, Map<String, String> titleMap)
    {
	// we always call this function on COMMUNITy ~> currentCommunity. As this community exists in the list, by definition it should Always have at least one child community OR one child collection
	
	// TODO: implement `filter` here
	// filtering implementation will ease the process of 'hiding' certain collections from the select Collection page
	// only by configuring it in the .cfg file. No need to peek on the source code.
	// right now, it is hardcoded. All collections under "Organ Systems" community will not appear.
	// beside that, the "omit" attribute has already done this also.
	//
	// filterList = configurationManager.getList(...)
	// filterList = attribute_filter
	// if( filterList.indexOf(current) )
	//
	// QUICKFIX ONLY
	if( omit.contains(current) ) return "";
	
	StringBuffer buf = new StringBuffer();
	
	if(!current.equals(TOP)) {
		// TODO enhancement - this could see some improvement | 
		// change color when there is at least one descendant selected
		buf.append("<div class='panel panel-default'>");
		buf.append("<div class='panel-heading' id='" + pHeading + Integer.toString(counter) + "'>");
		buf.append("<a role='button' data-toggle='collapse' data-parent='#" + prefix + parentCounter + "' ");
		buf.append("href='#" + pBody + Integer.toString(counter) + "' >");
		buf.append(titleMap.get(current) + "</a>");
		buf.append("</div>"); // closes .panel-heading

		buf.append("<div class='panel-collapse collapse' id='" + pBody + Integer.toString(counter) +"' >");
		buf.append("<div class='panel-body'>");

	}

	// whatever happens, counter has been used, so it must change!
	int currentCounter = counter++;

	if ( comMap.containsKey(current) )
	{
		buf.append("<div class='panel-group' id='" + prefix + Integer.toString(currentCounter) + "' >");
		Iterator<String> it = comMap.get(current).iterator();
		while(it.hasNext()) {
			buf.append( generate(it.next(), currentCounter, comMap, colMap, titleMap) );
		}
		buf.append("</div>"); // closes .panel-group
	}

	if( colMap.containsKey(current) )
	{
		buf.append("<div>");	
		String elemType = this.checkbox ? "checkbox" : "radio";
		Iterator<String> it = colMap.get(current).iterator();
		while(it.hasNext()) {
			String col = it.next();
			buf.append("<label><input type='" + elemType + "' name='" + name + "' value='" + titleMap.get("id-" + col) + "' ");
			if( this.collection.equals( titleMap.get("id-" + col) ) )
				buf.append("disabled='disabled' checked='checked'");
			else if( selectedCollections.contains( titleMap.get("id-" + col) ) )
				buf.append(" checked='checked' ");
			buf.append("> " + titleMap.get(col) + "</input></label><br/>" );
		}
		buf.append("</div>");
	}

	if(!current.equals(TOP)) {
		buf.append("</div>"); // closes .panel-body
		buf.append("</div>"); // closes .panel-collapse
		buf.append("</div>"); // closes .panel
	}
	return buf.toString();
    }

}

