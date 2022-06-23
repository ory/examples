package api

type (
	Subreddit struct {
		Name        string `json:"name"`
		Description string `json:"desc"`
		Status      int    `json:"status"`
	}
	Thread struct {
		Title       string `json:"title"`
		Text        string `json:"text"`
		Link        string `json:"link"`
		Status      string `json:"status"`
		SubredditID int    `json:"subreddit_id"`
	}
	Comment struct {
		Text        string `json:"text"`
		ThreadID    int    `json:"thread_id"`
		ParentID    int    `json:"parent_id"`
		Link        string `json:"link"`
		Status      string `json:"status"`
		SubredditID int    `json:"subreddit_id"`
	}
	SubredditResponse struct {
		Results []Subreddit `json:"results"`
	}
)
