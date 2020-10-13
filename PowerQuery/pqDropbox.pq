/* Link https://github.com/ImkeF/M/blob/master/Library/AccessingData.DropboxFolder.pq  */
let func =
    (optional folder as text) => 
let    data = [
        path = if folder = null then "" else folder,
        recursive = true,
        include_media_info = false,
        include_deleted = false,
        include_has_explicit_shared_members = false,
        include_mounted_folders =  true,
        include_non_downloadable_files = false
    ],
    header = [  
        #"Authorization" = "Bearer " & pDropboxToken,
        #"Content-Type"  = "application/json"
    ],
    response = Web.Contents("https://api.dropboxapi.com", [RelativePath = "/2/files/list_folder", Content=Json.FromValue(data), Headers=header ] ),
    out = Json.Document(response,1252),
    entries = out[entries],
    ToTable = Table.FromList(entries, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    ExpandProperties = Table.ExpandRecordColumn(ToTable, "Column1", {".tag", "name", "path_lower", "path_display", "id", "client_modified", "server_modified", "rev", "size", "is_downloadable", "content_hash"}, {".tag", "name", "path_lower", "path_display", "id", "client_modified", "server_modified", "rev", "size", "is_downloadable", "content_hash"}),
    FilterOnlyDownloadable = Table.SelectRows(ExpandProperties, each ([is_downloadable] = true)),
    RetrieveContent = Table.AddColumn(FilterOnlyDownloadable, "File", each Web.Contents("https://content.dropboxapi.com", [RelativePath = "/2/files/download", Headers=[#"Dropbox-API-Arg" = "{""path"" : """ & [path_display] & """}", #"Authorization" = header[Authorization] ] ]))
in
RetrieveContent,
documentation = [	
    Documentation.Name =  " AccessingData.DropboxFolder", 
    Documentation.Description = "    Returns a table with contents from your selected Dropbox folder" , 
    Documentation.LongDescription = "    Returns a table with contents from your selected Dropbox folder. The optional field 'folder' allows you to access sub-folders within the main folder.", 
    Documentation.Category = "    Accessing data functions", 
    Documentation.Source = "    local", 
    Documentation.Author = "    Imke Feldmann: www.TheBIccountant.com ", 
    Documentation.Examples = {[
        Description =  "    ", 
        Code = "    Check this blogpost explaining how it works: http://wp.me/p6lgsG-AA ", 
        Result = ""
    ]}
]
in	
    Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
