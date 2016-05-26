var SearchBox = React.createClass({
  getInitialState: function() {
    return this.props;
  },
  handleSearchSubmit: function(searchParams) {
    fetch('/api/search?' + $.param(searchParams))
      .then(function(response){
        return response.json();
      })
      .then(function(json){
        this.setState({ data: json });
      }.bind(this));
  },
  render: function(){
    return (
      <div className="search-box">
        <SearchForm onSearchSubmit={this.handleSearchSubmit} />
        <SearchResult data={this.state.data} />
      </div>
    )
  }
})

var SearchResult = React.createClass({
  render: function(){
    return (
      <div className="search-result">
        {this.props.data.name}
        <img className="search-result-image" src={this.props.data.imageUrl}></img>
        <button className="alternate-versions">View Alternates</button>
      </div>
    )
  }
});

var SearchForm = React.createClass({

  getInitialState: function() {
    return { search: '' };
  },

  handleSearchChange: function(e) {
    this.setState({search: e.target.value});
  },

  handleSubmit: function(e) {
    e.preventDefault();
    var search = this.state.search.trim();
    if (!search) {
      return;
    }
    this.props.onSearchSubmit({query: search});
    this.setState({search: ''});
  },

  render: function(){
    return (
      <form className="searchForm" onSubmit={this.handleSubmit}>
        <input name="utf8" type="hidden" value="✓"/>
        <input type="text" id="search" value={this.state.search} onChange={this.handleSearchChange} />
        <input type="submit" value="Search"/>
      </form>
    )
  }
})
