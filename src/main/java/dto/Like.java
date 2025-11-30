package dto;

public class Like {
    private String memberId;
    private int recipeId;

    public Like() {}

    public Like(String memberId, int recipeId) {
        this.memberId = memberId;
        this.recipeId = recipeId;
    }

    public String getMemberId() {
        return memberId;
    }

    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }

    public int getRecipeId() {
        return recipeId;
    }

    public void setRecipeId(int recipeId) {
        this.recipeId = recipeId;
    }
}
